class Attendee < ActiveRecord::Base
  belongs_to :attendance
  belongs_to :attendee_type
  validates_presence_of :attendance
  validates_presence_of :attendee_type

  def event
    return attendance.event if attendance
    return nil
  end

  def event_title
    return attendance.event_title if attendance
    return "NO ATTENDANCE"
  end

  def phone
    return attendance.user.phone unless attendance.blank? or attendance.user.blank?
    return ""
  end

  def address
    return attendance.user.address unless attendance.blank? or attendance.user.blank?
    return ""
  end

  def to_s
    "#{name} (#{attendee_type})"
  end

end
