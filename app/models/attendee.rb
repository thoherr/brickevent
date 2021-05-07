# encoding: utf-8
class Attendee < ApplicationRecord
  belongs_to :attendance
  belongs_to :attendee_type
  validates_presence_of :attendance
  validates_presence_of :attendee_type

  validate :shirt_count_positive_when_size_given

  def event
    attendance&.event
  end

  def event_title
    attendance&.event_title || "NO ATTENDANCE"
  end

  def attendee_email
    return self.email unless self.email.blank?
    return attendance&.user&.email unless attendance&.user.blank?
    ""
  end

  def phone
    return attendance&.user&.phone unless attendance&.user.blank?
    ""
  end

  def address
    return attendance&.user&.address unless attendance&.user.blank?
    ""
  end

  def to_s
    "#{name} (#{attendee_type})"
  end

  # CSV Stuff
  def Attendee.csv_array_header(event)
       return ["ID","Typ","Bestätigt","Name","LUG","Nickname","EMail","Telefon", "Adresse", "AFOLs-Abend","Ticket",event.label_option_1,event.label_option_2,event.label_option_3,event.label_option_4,event.label_option_5,"Bemerkungen","Anzahl Event-Shirts","Shirt-Größe","Zuletzt geändert"]
  end

  def csv_array
    [id,
     attendee_type.name, is_approved?,
     StringSanitizer.sanitize_encoding(name),
     StringSanitizer.sanitize_encoding(lug),
     StringSanitizer.sanitize_encoding(nickname),
     email, phone,
     StringSanitizer.sanitize_encoding(address),
     afols_event, needs_ticket, option_1, option_2, option_3, option_4, option_5,
     StringSanitizer.sanitize_encoding(remarks),
     number_of_shirts, shirt_size,
     updated_at.strftime("%F %T")]
  end

  protected

  def shirt_count_positive_when_size_given
    errors.add('T-Shirts', 'Die Anzahl muss größer 0 sein, wenn eine Größe ausgewählt wurde') if number_of_shirts.blank? && !shirt_size.blank?
  end

end
