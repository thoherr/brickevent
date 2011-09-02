class Attendance < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  has_many :attendees
  has_many :accommodations
  has_many :exhibits
end
