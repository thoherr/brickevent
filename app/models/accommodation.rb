class Accommodation < ActiveRecord::Base
  belongs_to :attendance
  belongs_to :accommodation_type

  validates_presence_of :attendance
  validates_presence_of :accommodation_type
  validates_presence_of :count

  def event_title
    return attendance.event_title if attendance
    return "NO ATTENDANCE"
  end

  def to_s
    "#{count} #{accommodation_type}"
  end

end
