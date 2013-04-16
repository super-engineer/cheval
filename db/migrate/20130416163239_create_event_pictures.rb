class CreateEventPictures < ActiveRecord::Migration
  def change
    create_table :event_pictures do |t|
      t.references :event

      t.timestamps
    end
    add_index :event_pictures, :event_id
  end
end
