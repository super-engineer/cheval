class PrintMedium < ActiveRecord::Base
  attr_accessible :hidden, :image
  has_attached_file :image, :styles => { :thumb => "100x140!", :cropped => "507x700!" }, :default_url => "/images/:style/missing.png"  
end
