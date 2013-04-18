class SliderImage < ActiveRecord::Base
  attr_accessible :hidden, :image
  has_attached_file :image, :styles => { :thumb => "300x100!", :cropped => "1200x400!" }, :default_url => "/images/:style/missing.png"
end
