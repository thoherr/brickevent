class AttendeeType < ActiveRecord::Base
  attr_protected :id
  has_many :attendees

  def to_s
    name
  end

end
