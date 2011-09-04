class Accommodation < ActiveRecord::Base
  belongs_to :attendance
  belongs_to :accommodation_type

  validates_presence_of :attendance
  validates_presence_of :accommodation_type
  validates_presence_of :count
end
