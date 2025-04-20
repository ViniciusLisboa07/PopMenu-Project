class ChangeDescriptionToOptional < ActiveRecord::Migration[7.1]
  def change
    change_column_null :menus, :description, true
    change_column_null :menu_items, :description, true
  end
end
