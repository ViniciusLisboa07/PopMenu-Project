require 'rails_helper'

RSpec.describe MenuItem, type: :model do

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(build(:menu_item)).to be_valid
    end

    it 'is not valid without a name' do
      expect(build(:menu_item, name: nil)).to_not be_valid
    end

    it 'is not valid without a price' do
      expect(build(:menu_item, price: nil)).to_not be_valid
    end

    it 'is not valid without a menu' do
      expect(build(:menu_item, :with_menus, menus: []).menus).to be_empty
    end

    it 'is not valid without a description' do
      expect(build(:menu_item, :with_menus, menus: [create(:menu)], description: nil)).to_not be_valid
    end

    it 'validates uniqueness of name' do
      create(:menu_item, name: 'Pizza')
      expect(build(:menu_item, name: 'Pizza')).to_not be_valid
    end
  end

  describe 'associations' do
    it 'has many menus' do
      association = described_class.reflect_on_association(:menus)
      expect(association.macro).to eq :has_many
    end
  end

  describe 'many to many association with menus' do
    it 'can have multiple menus' do
      menu_item = create(:menu_item, :with_multiple_menus, menus_count: 2)
      expect(menu_item.menus.count).to eq(2)
    end
  end
end