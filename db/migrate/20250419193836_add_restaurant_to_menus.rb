class AddRestaurantToMenus < ActiveRecord::Migration[7.1]
  def up
    restaurant = Restaurant.find_or_create_by(name: 'Popmenu')
    add_reference :menus, :restaurant, null: true, foreign_key: true
    Menu.update_all(restaurant_id: restaurant.id)
    change_column_null :menus, :restaurant_id, false
  end

  def down
    remove_reference :menus, :restaurant, foreign_key: true
  end
end
