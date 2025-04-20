FactoryBot.define do
  factory :menu_item do
    sequence(:name) { |n| "#{Faker::Food.dish} ##{n}" }
    description { Faker::Food.description }
    price { Faker::Number.decimal(l_digits: 2) }
    
    trait :with_menus do
      transient do
        menus { [] }
        menus_count { 0 }
      end
      
      after(:create) do |menu_item, evaluator|
        menu_item.menus << evaluator.menus if evaluator.menus.any?
        
        if evaluator.menus_count > 0
          create_list(:menu, evaluator.menus_count, menu_items: [menu_item])
        elsif menu_item.menus.empty?
          menu_item.menus << create(:menu)
        end
      end
    end
    
    trait :with_multiple_menus do
      transient do
        menus_count { 3 }
      end
      
      after(:create) do |menu_item, evaluator|
        create_list(:menu, evaluator.menus_count, menu_items: [menu_item])
      end
    end

  end
end
