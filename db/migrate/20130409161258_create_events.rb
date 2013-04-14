class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.date :scheduled_on
      t.text :description
      t.boolean :done

      t.timestamps
    end
  end
end
