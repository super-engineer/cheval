class AddHiddenToSpecialMenus < ActiveRecord::Migration
  def change
    add_column :special_menus, :hidden, :boolean
  end
end
