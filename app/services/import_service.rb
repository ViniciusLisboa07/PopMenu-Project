class ImportService
    def initialize(json_data)
      @json_data = json_data
      @logs = []
      @status = :success
    end
  
    def call
      ActiveRecord::Base.transaction do
        import_restaurants
      rescue StandardError => e
        @logs << "Error: #{e.message}"
        @status = :failure
        raise ActiveRecord::Rollback
      end
      { logs: @logs, status: @status }
    end
  
    private
  
    def import_restaurants
      restaurants = @json_data['restaurants'] || []
      unless restaurants.is_a?(Array)
        @logs << 'Error: restaurants must be an array'
        @status = :failure
        return
      end
  
      restaurants.each do |restaurant_data|
        restaurant = import_restaurant(restaurant_data)
        import_menus(restaurant, restaurant_data['menus']) if restaurant
      end
    end
  
    def import_restaurant(restaurant_data)
      restaurant = Restaurant.find_or_initialize_by(name: restaurant_data['name'])
      if restaurant.save
        @logs << "Restaurant '#{restaurant.name}' created or found successfully"
        restaurant
      else
        @logs << "Failed to create restaurant '#{restaurant_data['name']}': #{restaurant.errors.full_messages.join(', ')}"
        @status = :failure
        return nil
      end
    end
  
    def import_menus(restaurant, menus_data)
      menus_data = menus_data || []
      unless menus_data.is_a?(Array)
        @logs << "Error: menus for restaurant '#{restaurant.name}' must be an array"
        @status = :failure
        return
      end
  
      menus_data.each do |menu_data|
        menu = import_menu(restaurant, menu_data)
        import_menu_items(menu, menu_data['menu_items'] || menu_data['dishes']) if menu
      end
    end
  
    def import_menu(restaurant, menu_data)
      return unless menu_data['name'].present?
  
      menu = restaurant.menus.find_or_initialize_by(name: menu_data['name'])
      menu.active = true
      if menu.save
        @logs << "Menu '#{menu.name}' created or found for restaurant '#{restaurant.name}'"
        menu
      else
        @logs << "Failed to create menu '#{menu_data['name']}' for restaurant '#{restaurant.name}': #{menu.errors.full_messages.join(', ')}"
        @status = :failure
        nil
      end
    end
  
    def import_menu_items(menu, menu_items_data)
      menu_items_data = menu_items_data || []
      unless menu_items_data.is_a?(Array)
        @logs << "Error: menu items for menu '#{menu.name}' must be an array"
        @status = :failure
        return
      end
  
      menu_items_data.each_with_index do |item_data, index|
        import_menu_item(menu, item_data, index)
      end
    end
  
    def import_menu_item(menu, item_data, index)
      item_name = item_data['name'] || 'Unnamed Item'
      @logs << "Processing MenuItem '#{item_name}' (index #{index}) for menu '#{menu.name}'"
  
      unless item_data['name'].present? && item_data['price'].present?
        @logs << "Failed to process MenuItem (index #{index}): Missing name or price"
        @status = :failure
        return
      end
  
      menu_item = MenuItem.find_by(name: item_data['name'])
      if menu_item
        @logs << "Menu item '#{menu_item.name}' already exists"

        if menu_item.price != item_data['price']
          menu_item.price = item_data['price']
          @logs << "Menu item '#{menu_item.name}' updated with price #{menu_item.price}"
        end
      else
        menu_item = MenuItem.new(name: item_data['name'], price: item_data['price'])
        @logs << "Menu item '#{menu_item.name}' created with price #{menu_item.price}"
      end
    
      if menu_item.save
        if menu.menu_items.include?(menu_item)
          @logs << "MenuItem '#{menu_item.name}' already associated with menu '#{menu.name}'"
        else
          menu.menu_items << menu_item
          @logs << "MenuItem '#{menu_item.name}' associated with menu '#{menu.name}'"
        end
      else
        @logs << "Failed to create or update MenuItem '#{item_data['name']}' (index #{index}): #{menu_item.errors.full_messages.join(', ')}"
        @status = :failure
      end
    end
  end