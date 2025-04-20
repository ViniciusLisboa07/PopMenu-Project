require 'rails_helper'

RSpec.describe MenuMenuItem, type: :model do
  describe 'associations' do
    it 'belongs to menu' do
      association = described_class.reflect_on_association(:menu)
      expect(association.macro).to eq :belongs_to
    end
    
    it 'belongs to menu_item' do
      association = described_class.reflect_on_association(:menu_item)
      expect(association.macro).to eq :belongs_to
    end
  end

  describe 'validations' do
    it 'validates uniqueness of menu_id scoped to menu_item_id' do
      menu = create(:menu)
      menu_item = create(:menu_item)
      described_class.create!(menu: menu, menu_item: menu_item)
      
      duplicate = described_class.new(menu: menu, menu_item: menu_item)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:menu_id]).to include("has already been taken")
      
      different_item = create(:menu_item)
      valid_record = described_class.new(menu: menu, menu_item: different_item)
      expect(valid_record).to be_valid
    end
  end
end