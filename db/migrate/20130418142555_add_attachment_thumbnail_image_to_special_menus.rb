class AddAttachmentThumbnailImageToSpecialMenus < ActiveRecord::Migration
  def self.up
    change_table :special_menus do |t|
      t.attachment :thumbnail_image
    end
  end

  def self.down
    drop_attached_file :special_menus, :thumbnail_image
  end
end
