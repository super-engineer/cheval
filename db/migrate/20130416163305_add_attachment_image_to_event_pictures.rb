class AddAttachmentImageToEventPictures < ActiveRecord::Migration
  def self.up
    change_table :event_pictures do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :event_pictures, :image
  end
end
