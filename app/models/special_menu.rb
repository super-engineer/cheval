class SpecialMenu < ActiveRecord::Base
  attr_accessible :description, :name, :menu_images_attributes, :hidden
  has_many :menu_images
  accepts_nested_attributes_for :menu_images, :allow_destroy => true
  default_scope where("hidden = false").order("created_at DESC")
end
