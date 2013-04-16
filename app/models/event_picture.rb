class EventPicture < ActiveRecord::Base
  belongs_to :event
  has_attached_file :image, :styles => { :thumb => "100x100#", }, :default_url => "/images/:style/missing.png"  
  attr_accessible :image
end
