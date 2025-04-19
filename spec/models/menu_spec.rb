require 'rails_helper'

RSpec.describe Menu, type: :model do
  it 'is valid with valid attributes' do
    expect(build(:menu)).to be_valid
  end

  it 'is not valid without a name' do
    expect(build(:menu, name: nil)).to_not be_valid
  end

  it 'is not valid without a description' do
    expect(build(:menu, description: nil)).to_not be_valid
  end

  it 'is not valid without an active status' do
    expect(build(:menu, active: nil)).to_not be_valid
  end

end