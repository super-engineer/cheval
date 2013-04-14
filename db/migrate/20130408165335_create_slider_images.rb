class CreateSliderImages < ActiveRecord::Migration
  def change
    create_table :slider_images do |t|
      t.boolean :hidden
      t.timestamps
    end
    add_attachment :slider_images, :image
  end
end
