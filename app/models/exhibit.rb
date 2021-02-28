# encoding: utf-8
class Exhibit < ApplicationRecord
  belongs_to :attendance
  belongs_to :unit
  has_many :installation_parts, :class_name => "Exhibit", :foreign_key => "installation_exhibit_id"
  belongs_to :installation, :class_name => "Exhibit", :foreign_key => "installation_exhibit_id", optional: true
  has_many :subsequent_exhibits, :class_name => "Exhibit", :foreign_key => "former_exhibit_id", :dependent => :nullify
  belongs_to :former_exhibit, :class_name => "Exhibit", :foreign_key => "former_exhibit_id", optional: true

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

  def size_in_square_meters
    return size_x_meter * size_y_meter unless size_x_meter.blank? or size_y_meter.blank?
    0.0
  end

  def required_space_in_square_meters
    return 1.0 if size_x_meter.blank? or size_y_meter.blank?
    size_x_with_buffer = if size_x_meter < 0.4 then 0.5 elsif size_x_meter < 0.65 then Math.sqrt(0.5) elsif size_x_meter > 1.00 && size_x_meter < 1.40 then 1.5 else size_x_meter.ceil end
    size_y_with_buffer = if size_y_meter < 0.4 then 0.5 elsif size_y_meter < 0.65 then Math.sqrt(0.5) elsif size_y_meter > 1.00 && size_y_meter < 1.40 then 1.5 else size_y_meter.ceil end
    return size_x_with_buffer * size_y_with_buffer
  end

  def size_text
    unless size_x_meter.blank?
      return size_x_meter.to_s +
          if size_y_meter.blank? then "" else " x " + size_y_meter.to_s end +
          if size_z_meter.blank? then "" else " x " + size_z_meter.to_s end
    end
    "MISSING"
  end

  def to_s
    name
  end

  # CSV Stuff
  def Exhibit.csv_array_header
       return [ "ID", "Bestätigt", "Name", "MOC","Beschreibung","Anmerkungen","URL", "Größe x", "Größe y", "Größe z", "Größe Einheit", "Größe x (m)", "Größe y (m)", "Größe z (m)", "Versicherungswert","Baustunden","Anzahl Steine", "Strom?", "Sammeltransport", "Gemeinschaftsprojekt?", "Teil Gemeinschaftsprojekt", "Name Gemeinschaftsprojekt", "Zuletzt geändert" ]
  end
  def csv_array
    return [ id,
             is_approved?, StringSanitizer.sanitize_encoding(user_name),
             StringSanitizer.sanitize_encoding(name),
             StringSanitizer.sanitize_encoding(description),
             StringSanitizer.sanitize_encoding(remarks),
             url, size_x, size_y, size_z,
             (unit.nil? ? 'cm' : unit.name),
             size_x_meter, size_y_meter, size_z_meter,
             value, building_hours, brick_count,
             needs_power_supply, needs_transportation,
             is_installation, is_part_of_installation, installation_exhibit_name,
             updated_at.strftime("%F %T") ]
  end

end
