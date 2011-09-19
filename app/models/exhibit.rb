class Exhibit < ActiveRecord::Base
  belongs_to :attendance
  has_many :installation_parts, :class_name => "Exhibit"
  belongs_to :installation, :class_name => "Exhibit", :foreign_key => "installation_exhibit_id"

  def event_installations
    return attendance.event_installations if attendance
    return []
  end

  def event_title
    return attendance.event_title if attendance
    return "NO ATTENDANCE"
  end

  def to_s
    name
  end

end
