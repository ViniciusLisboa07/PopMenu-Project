FactoryBot.define do
  factory :menu do
    sequence(:name) { |n| "#{Faker::Restaurant.name} ##{n}" }
    description { Faker::Restaurant.description }
    active { true }
    restaurant { create(:restaurant) }
  end
end 