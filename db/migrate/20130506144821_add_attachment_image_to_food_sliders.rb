class AddAttachmentImageToFoodSliders < ActiveRecord::Migration
  def self.up
    change_table :food_sliders do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :food_sliders, :image
  end
end
