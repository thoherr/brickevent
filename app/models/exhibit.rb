# encoding: utf-8
class Exhibit < ApplicationRecord
  belongs_to :attendance
  belongs_to :unit
  has_many :installation_parts, :class_name => "Exhibit", :foreign_key => "installation_exhibit_id"
  belongs_to :installation, :class_name => "Exhibit", :foreign_key => "installation_exhibit_id", optional: true
  has_many :subsequent_exhibits, :class_name => "Exhibit", :foreign_key => "former_exhibit_id", :dependent => :nullify
  belongs_to :former_exhibit, :class_name => "Exhibit", :foreign_key => "former_exhibit_id", optional: true

  before_save :calculate_size_in_meters_and_centimeters

  def calculate_size_in_meters_and_centimeters
    factor_to_cm = if unit then unit.factor_to_cm else 1.0 end # assume cm if not known
    if size_x.blank?
      self.size_x_meter = nil
      self.size_x_centimeter = nil
    else
      self.size_x_centimeter = size_x * factor_to_cm
      self.size_x_meter = size_x_centimeter / 100.0
    end
    if size_y.blank?
      self.size_y_meter = nil
      self.size_y_centimeter = nil
    else
      self.size_y_centimeter = size_y * factor_to_cm
      self.size_y_meter = size_y_centimeter / 100.0
    end
    if size_z.blank?
      self.size_z_meter = nil
      self.size_z_centimeter = nil
    else
      self.size_z_centimeter = size_z * factor_to_cm
      self.size_z_meter = size_z_centimeter / 100.0
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
    self.get_ancestor.is_version_of?(other.get_ancestor)
  end

  def copy_for_new_attendance
    new_exhibit = self.dup
    new_exhibit.is_approved = false
    new_exhibit.attendance_id = nil
    new_exhibit.is_part_of_installation = false
    new_exhibit.installation = nil
    new_exhibit.former_exhibit_id = self.id
    new_exhibit
  end

  def event_installations
    attendance&.event_installations || []
  end

  def event_title
    attendance&.event_title || "NO ATTENDANCE"
  end

  def owner
    attendance&.owner
  end

  def user_name
    attendance&.user_name || "NO ATTENDANCE"
  end

  def user_email
    attendance&.user_email || "NO ATTENDANCE"
  end

  def user_lug
    attendance&.user_lug || "NO ATTENDANCE"
  end

  def installation_exhibit_name
    installation&.name|| "-"
  end

  def size_in_square_meters
    return size_x_meter * size_y_meter unless size_x_meter.blank? or size_y_meter.blank?
    0.0
  end

  def required_space_in_square_meters
    return 1.0 if size_x_meter.blank? or size_y_meter.blank?
    size_x_with_buffer = if size_x_meter < 0.4 then 0.5 elsif size_x_meter < 0.65 then Math.sqrt(0.5) elsif size_x_meter > 1.00 && size_x_meter < 1.40 then 1.5 else size_x_meter.ceil end
    size_y_with_buffer = if size_y_meter < 0.4 then 0.5 elsif size_y_meter < 0.65 then Math.sqrt(0.5) elsif size_y_meter > 1.00 && size_y_meter < 1.40 then 1.5 else size_y_meter.ceil end
    size_x_with_buffer * size_y_with_buffer
  end

  def size_text_in_cm
    unless size_x_centimeter.blank?
      return size_x_centimeter.to_s +
          if size_y_centimeter.blank? then "" else " x " + size_y_centimeter.to_s end +
          if size_z_centimeter.blank? then "" else " x " + size_z_centimeter.to_s end
    end
    "MISSING"
  end

  def to_s
    name
  end

  # CSV Stuff
  def Exhibit.csv_array_header
       return [ "ID", "Bestätigt", "Name", "Email", "MOC","Beschreibung","Anmerkungen","URL", "Größe x", "Größe y", "Größe z", "Größe Einheit", "Größe x (cm)", "Größe y (cm)", "Größe z (cm)", "Versicherungswert", "Versicherungswert Anlage", "Baustunden", "Anzahl Steine", "Strom?", "Sammeltransport", "Gemeinschaftsprojekt?", "Teil Gemeinschaftsprojekt", "Name Gemeinschaftsprojekt", "Zuletzt geändert" ]
  end

  def csv_array
    [id,
     is_approved?, StringSanitizer.sanitize_encoding(user_name),
     StringSanitizer.sanitize_encoding(user_email),
     StringSanitizer.sanitize_encoding(name),
     StringSanitizer.sanitize_encoding(description),
     StringSanitizer.sanitize_encoding(remarks),
     url, size_x, size_y, size_z,
     (unit.nil? ? 'cm' : unit.name),
     size_x_centimeter, size_y_centimeter, size_z_centimeter,
     is_installation ? 0.0 : value,
     is_installation ? value : 0.0,
     building_hours, brick_count,
     needs_power_supply, needs_transportation,
     is_installation, is_part_of_installation, installation_exhibit_name,
     updated_at.strftime("%F %T")]
  end

end
