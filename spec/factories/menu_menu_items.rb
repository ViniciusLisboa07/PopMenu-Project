FactoryBot.define do
  factory :menu_menu_item do
    menu { create(:menu) }
    menu_item { create(:menu_item) }
  end
end
