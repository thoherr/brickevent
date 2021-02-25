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

  def user_name
    return attendance.user_name if attendance
    return "NO ATTENDANCE"
  end

  def accommodation_type_name
    return accommodation_type.name if accommodation_type
    return "NO ACCOMODATION_TYPE"
  end

  def to_s
    "#{count} #{accommodation_type}"
  end

end
