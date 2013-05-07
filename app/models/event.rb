class Event < ActiveRecord::Base
  has_many :event_pictures
  attr_accessible :description, :done, :name, :scheduled_on, :poster, :event_pictures_attributes, :thumbnail_poster, :youtube_url
  has_attached_file :poster, :default_url => "/assets/missing.png"
  has_attached_file :thumbnail_poster, :styles => { :cropped => "270x270!" }, :default_url => "/assets/missing.png"
  # default_scope order("created_at DESC")
  scope :upcoming, where("scheduled_on >= ?", (Date.today-1.days)).order("scheduled_on ASC")
  scope :past, where("scheduled_on < ?", (Date.today-1.days)).order("scheduled_on DESC")
  validates_presence_of :name, :scheduled_on, :poster, :description
  accepts_nested_attributes_for :event_pictures, :allow_destroy => true
end
