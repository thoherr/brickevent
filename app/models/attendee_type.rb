class AttendeeType < ApplicationRecord
  has_many :attendees

  def to_s
    name
  end

end
