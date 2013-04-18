class SpecialMenu < ActiveRecord::Base
  attr_accessible :description, :name, :menu_images_attributes, :hidden, :thumbnail_image
  has_many :menu_images
  has_attached_file :thumbnail_image, :styles => { :cropped => "270x270!" }, :default_url => "/assets/missing.png"
  accepts_nested_attributes_for :menu_images, :allow_destroy => true
  default_scope where("hidden = false").order("created_at DESC")
end
