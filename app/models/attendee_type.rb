class AttendeeType < ActiveRecord::Base
  has_many :attendees
end
