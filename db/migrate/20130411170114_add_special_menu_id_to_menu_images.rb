class AddSpecialMenuIdToMenuImages < ActiveRecord::Migration
  def change
    add_column :menu_images, :special_menu_id, :integer
    add_index :menu_images, :special_menu_id
  end
end
