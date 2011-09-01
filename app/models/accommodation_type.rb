class AccommodationType < ActiveRecord::Base
  has_many :attendees
end
