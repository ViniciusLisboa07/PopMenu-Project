class Menu < ApplicationRecord
  has_many :menu_items, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true
  validates :active, inclusion: { in: [true, false] }
end
