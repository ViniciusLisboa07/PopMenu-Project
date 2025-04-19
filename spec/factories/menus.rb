FactoryBot.define do
  factory :menu do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    active { true }
    restaurant { create(:restaurant) }
  end
end 