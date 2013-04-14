class CreatePressLinks < ActiveRecord::Migration
  def change
    create_table :press_links do |t|
      t.string :url
      t.text :description

      t.timestamps
    end
  end
end
