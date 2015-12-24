# encoding: UTF-8
class Exhibit < ActiveRecord::Base
  belongs_to :attendance
  belongs_to :unit
  has_many :installation_parts, :class_name => "Exhibit", :foreign_key => "installation_exhibit_id"
  belongs_to :installation, :class_name => "Exhibit", :foreign_key => "installation_exhibit_id"
  has_many :subsequent_exhibits, :class_name => "Exhibit", :foreign_key => "former_exhibit_id", :dependent => :nullify
  belongs_to :former_exhibit, :class_name => "Exhibit", :foreign_key => "former_exhibit_id"

  before_save :calculate_size_in_meters

  def calculate_size_in_meters
    factor = if unit then unit.factor else 0.01 end # assume cm if not known
    if size_x.blank?
      self.size_x_meter = nil
    else
      self.size_x_meter = size_x * factor
    end
    if size_y.blank?
      self.size_y_meter = nil
    else
      self.size_y_meter = size_y * factor
    end
    if size_z.blank?
      self.size_z_meter = nil
    else
      self.size_z_meter = size_z * factor
    end
  end

  def get_ancestor
    return self if former_exhibit.nil?
    return former_exhibit.get_ancestor
  end

  def is_first?
    former_exhibit.nil?
  end

  def is_latest?
    subsequent_exhibits.empty?
  end

  def is_version_of?(other)
    return true if other == self
    return false if self.is_first? && other.is_first?
    return self.get_ancestor.is_version_of?(other.get_ancestor)
  end

  def copy_for_new_attendance
    new_exhibit = self.dup
    new_exhibit.attendance_id = nil
    new_exhibit.is_part_of_installation = false
    new_exhibit.installation = nil
    new_exhibit.former_exhibit_id = self.id
    new_exhibit
  end

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
       return [ "Bestätigt", "Name", "MOC","Beschreibung","URL","Größe in Studs","Größe", "Größe x", "Größe y", "Größe z", "Größe Einheit", "Größe x (m)", "Größe y (m)", "Größe z (m)", "Versicherungswert","Baustunden","Anzahl Steine", "Strom?", "Sammeltransport", "Gemeinschaftsprojekt?", "Teil Gemeinschaftsprojekt", "Name Gemainschaftsprojekt" ]
  end
  def csv_array
      return [ is_approved?, user_name, name, description, url, size_studs, size, size_x, size_y, size_z, (unit.nil? ? 'cm' : unit.name), size_x_meter, size_y_meter, size_z_meter, value, building_hours, brick_count, needs_power_supply, needs_transportation, is_installation, is_part_of_installation, installation_exhibit_name ]
  end

end
