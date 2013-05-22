class CreatePrintMedia < ActiveRecord::Migration
  def change
    create_table :print_media do |t|
      t.boolean :hidden

      t.timestamps
    end
  end
end
