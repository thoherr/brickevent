class Attendee < ActiveRecord::Base
  belongs_to :attendance
  belongs_to :attendee_type
end
