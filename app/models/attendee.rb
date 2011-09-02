class Attendee < ActiveRecord::Base
  belongs_to :attendance
  belongs_to :event
  belongs_to :accommodation_type
  belongs_to :attendee_type
end
