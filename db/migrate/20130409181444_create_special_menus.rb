class CreateSpecialMenus < ActiveRecord::Migration
  def change
    create_table :special_menus do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
