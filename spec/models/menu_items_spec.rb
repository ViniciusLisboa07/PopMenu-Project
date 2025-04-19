require 'rails_helper'

RSpec.describe MenuItem, type: :model do
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
end