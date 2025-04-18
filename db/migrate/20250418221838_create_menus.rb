class CreateMenus < ActiveRecord::Migration[7.1]
  def change
    create_table :menus do |t|
      t.string :name
      t.text :description
      t.boolean :active

      t.timestamps
    end
  end
end
