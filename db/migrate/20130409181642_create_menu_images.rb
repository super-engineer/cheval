class CreateMenuImages < ActiveRecord::Migration
  def change
    create_table :menu_images do |t|
      t.integer :page_number

      t.timestamps
    end
  end
end
