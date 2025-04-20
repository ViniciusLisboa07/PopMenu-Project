require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      restaurant = create(:restaurant)
      expect(restaurant).to be_valid
    end
  end
end
