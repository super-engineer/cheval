class SliderImage < ActiveRecord::Base
  attr_accessible :hidden, :image
  has_attached_file :image, :styles => { :thumb => "288x90!", :cropped => "960x300!" }, :default_url => "/images/:style/missing.png"
end
