class Exhibit < ActiveRecord::Base
  belongs_to :attendance
  has_many :installation_parts, :class_name => "Exhibit", :foreign_key => "installation_exhibit_id"
  belongs_to :installation, :class_name => "Exhibit", :foreign_key => "installation_exhibit_id"

  def event_installations
    return attendance.event_installations if attendance
    return []
  end

  def event_title
    return attendance.event_title if attendance
    return "NO ATTENDANCE"
  end

  def user_name
    return attendance.user_name if attendance
    return "NO ATTENDANCE"
  end

  def user_lug
    return attendance.user_lug if attendance
    return "NO ATTENDANCE"
  end

  def installation_exhibit_name
    return installation.name if installation
    return "-"
  end

  def size_text
    return "k.A." if size.blank? && size_studs.blank?
    t1 = if size.blank? then "" else size + " cm" end
    t2 = if size_studs.blank? then "" else size_studs + " Noppen" end
    return t1 + if t1.blank? or t2.blank? then "" else ", " end + t2
  end

  def to_s
    name
  end

  # CSV Stuff
  def Exhibit.csv_array_header
       return ["Name", "MOC","Beschreibung","URL","Größe in Studs","Größe","Versicherungswert","Baustunden","Anzahl Steine", "Strom?", "Sammeltransport", "Gemeinschaftsprojekt?", "Teil Gemeinschaftsprojekt", "Name Gemainschaftsprojekt"]
  end
  def csv_array
      installation_exhibit_name = ""
      installation_exhibit_name = installation_exhibit.name if installation_exhibit
      return [ user_name, name, description, url, size_studs, size, value, building_hours, brick_count, needs_power_supply, needs_transportation, is_installation, is_part_of_installation, installation_exhibit_name ]
  end

end
