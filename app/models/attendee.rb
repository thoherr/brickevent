class Attendee < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  belongs_to :accommodation_type
end
