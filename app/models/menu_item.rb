class MenuItem < ApplicationRecord
  has_many :menu_menu_items, dependent: :destroy
  has_many :menus, through: :menu_menu_items

  validates :name, presence: true, uniqueness: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
