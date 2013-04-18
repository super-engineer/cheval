class AddAttachmentThumbnailPosterToEvents < ActiveRecord::Migration
  def self.up
    change_table :events do |t|
      t.attachment :thumbnail_poster
    end
  end

  def self.down
    drop_attached_file :events, :thumbnail_poster
  end
end
