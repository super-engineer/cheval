class PressLink < ActiveRecord::Base
  attr_accessible :description, :url
  has_attached_file :image, :styles => { :thumb => "120x120#" }, :default_url => "/images/:style/missing.png"  
  default_scope order("created_at DESC")
end