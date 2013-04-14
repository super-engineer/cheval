class MenuImage < ActiveRecord::Base
  belongs_to :special_menu
  attr_accessible :page_number, :image, :page_number
  has_attached_file :image, :styles => { :thumb => "100x140!", :cropped => "507x700!" }, :default_url => "/images/:style/missing.png"  
  default_scope order("page_number ASC")
end
