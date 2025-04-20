class RemoveMenuIdFromMenuItems < ActiveRecord::Migration[7.1]
  def up
    MenuItem.all.each do |menu_item|
      MenuMenuItem.create!(menu_id: menu_item.menu_id, menu_item_id: menu_item.id) if menu_item.menu_id
    end

    remove_reference :menu_items, :menu, foreign_key: true
  end

  def down
    add_reference :menu_items, :menu, foreign_key: true
    MenuMenuItem.find_each do |join|
      MenuItem.find(join.menu_item_id).update!(menu_id: join.menu_id)
    end
  end
end
