class AttendeeType < ActiveRecord::Base
  has_many :attendees

  def to_s
    name
  end

end
