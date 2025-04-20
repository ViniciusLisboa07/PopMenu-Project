require 'rails_helper'

RSpec.describe ImportService, type: :service do
  let(:json_data) do
    {
      'restaurants' => [
        {
          'name' => "Poppo's Cafe",
          'menus' => [
            {
              'name' => 'lunch',
              'menu_items' => [
                { 'name' => 'Burger', 'price' => 9.00 },
                { 'name' => 'Burger', 'price' => 9.00 }
              ]
            },
            {
              'name' => 'dinner',
              'dishes' => [
                { 'name' => 'Large Salad', 'price' => 8.00 }
              ]
            }
          ]
        }
      ]
    }
  end

  describe '#call' do
    subject { described_class.new(json_data).call }

    it 'imports restaurants, menus, and menu items with logs' do
      result = subject
      expect(result[:status]).to eq(:success)
      expect(result[:logs]).to include(
        "Restaurant 'Poppo's Cafe' created or found successfully",
        "Menu 'lunch' created or found for restaurant 'Poppo's Cafe'",
        "Processing MenuItem 'Burger' (index 0) for menu 'lunch'",
        "Menu item 'Burger' created with price 9.0",
        "MenuItem 'Burger' associated with menu 'lunch'",
        "Processing MenuItem 'Burger' (index 1) for menu 'lunch'",
        "Menu item 'Burger' already exists",
        "Menu 'dinner' created or found for restaurant 'Poppo's Cafe'",
        "Processing MenuItem 'Large Salad' (index 0) for menu 'dinner'",
        "Menu item 'Large Salad' created with price 8.0",
        "MenuItem 'Large Salad' associated with menu 'dinner'"
      )

      restaurant = Restaurant.find_by(name: "Poppo's Cafe")
      expect(restaurant).to be_present
      expect(restaurant.menus.count).to eq(2)
      expect(MenuItem.find_by(name: 'Burger').menus.count).to eq(1)
    end

    context 'with invalid restaurant data' do
      let(:json_data) do
        { 'restaurants' => [{ 'name' => nil }] }
      end

      it 'logs failure and does not create restaurant' do
        result = subject
        expect(result[:status]).to eq(:failure)
        expect(result[:logs]).to include(/Failed to create restaurant '': Name can't be blank/)
        expect(Restaurant.count).to eq(0)
      end
    end

    context 'with invalid menu item data' do
      let(:json_data) do
        {
          'restaurants' => [
            {
              'name' => "Poppo's Cafe",
              'menus' => [
                {
                  'name' => 'lunch',
                  'menu_items' => [
                    { 'name' => 'Burger', 'price' =>  -1}
                  ]
                }
              ]
            }
          ]
        }
      end

      it 'logs failure and rolls back' do
        result = subject
        expect(result[:status]).to eq(:failure)
        expect(result[:logs]).to include("Failed to create or update MenuItem 'Burger' (index 0): Price must be greater than or equal to 0")
        expect(MenuItem.count).to eq(0)
      end
    end
  end
end