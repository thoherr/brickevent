class Attendee < ActiveRecord::Base
  belongs_to :attendance
  belongs_to :attendee_type
  validates_presence_of :attendance
  validates_presence_of :attendee_type
  
  def to_s
    "#{name} (#{attendee_type})"
  end

  def event_title
    return attendance.event_title if attendance
    return "NO ATTENDANCE"
  end

end
