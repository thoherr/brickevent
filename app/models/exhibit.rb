class Exhibit < ActiveRecord::Base
  belongs_to :attendance

  def to_s
    name
  end

  def event_title
    return attendance.event_title if attendance
    return "NO ATTENDANCE"
  end

end
