class AddAttachmentImageToPrintMeadia < ActiveRecord::Migration
  def self.up
    change_table :print_media do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :print_media, :image
  end
end
