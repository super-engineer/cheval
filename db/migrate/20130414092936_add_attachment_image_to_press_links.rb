class AddAttachmentImageToPressLinks < ActiveRecord::Migration
  def self.up
    change_table :press_links do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :press_links, :image
  end
end
