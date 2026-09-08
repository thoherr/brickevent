# encoding: utf-8
class Attendee < ApplicationRecord
  include PersonName

  belongs_to :attendance
  belongs_to :attendee_type
  validates_presence_of :attendance
  validates_presence_of :attendee_type

  validate :shirt_count_positive_when_size_given

  after_create :generate_voucher_code

  ORDER_STATUSES = %w[pending paid expired canceled].freeze
  ACTIVE_ORDER_STATUSES = %w[pending paid].freeze

  def is_managed_by?(user)
    attendance&.is_managed_by?(user)
  end

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
    "#{full_name} (#{attendee_type})"
  end

  # pretix shop integration -------------------------------------------------

  def self.voucher_code_for(attendee_id)
    "#{attendee_id}-#{SecureRandom.uuid.upcase}"
  end

  # The voucher needs the id, so it is set right after the insert.
  def generate_voucher_code
    update_column(:voucher_code, Attendee.voucher_code_for(id)) if voucher_code.blank?
  end

  # Personal link into the pretix shop that redeems the attendee's voucher.
  def order_link
    return nil if voucher_code.blank? || event.nil? || !event.shop_configured?

    "#{event.shop_base_url}redeem?voucher=#{voucher_code}"
  end

  # A pending or paid order exists in pretix; the voucher is used up.
  def has_order?
    order_code.present? && ACTIVE_ORDER_STATUSES.include?(order_status)
  end

  def order_pending?
    order_code.present? && order_status == 'pending'
  end

  def show_ticket?
    ticket_secret.present? && order_status == 'paid'
  end

  def show_order_link?
    !!(event&.show_order_link? && order_link.present? && is_approved? && !has_order?)
  end


  # CSV Stuff
  def Attendee.voucher_csv_header
    ["ID", "Vorname", "Nachname", "EMail", "Voucher"]
  end

  def voucher_csv_array
    [id,
     StringSanitizer.sanitize_encoding(given_name),
     StringSanitizer.sanitize_encoding(family_name),
     attendee_email,
     voucher_code]
  end

  def Attendee.csv_array_header(event)
       return ["ID","Typ","Bestätigt","Vorname","Nachname","LUG","Nickname","EMail","Telefon", "Adresse", "AFOLs-Abend","Ticket",event.label_option_1,event.label_option_2,event.label_option_3,event.label_option_4,event.label_option_5,"Bemerkungen","Anzahl Event-Shirts","Shirt-Größe","Voucher","Bestell-Link","Bestellcode","Positions-ID","Bestellstatus","Ticket-Secret","Ticket-Link","Bestellung importiert","Zuletzt geändert"]
  end

  def csv_array
    [id,
     attendee_type.name, is_approved?,
     StringSanitizer.sanitize_encoding(given_name),
     StringSanitizer.sanitize_encoding(family_name),
     StringSanitizer.sanitize_encoding(lug),
     StringSanitizer.sanitize_encoding(nickname),
     email, phone,
     StringSanitizer.sanitize_encoding(address),
     afols_event, needs_ticket, option_1, option_2, option_3, option_4, option_5,
     StringSanitizer.sanitize_encoding(remarks),
     number_of_shirts, shirt_size,
     voucher_code, order_link,
     order_code, order_position_id, order_status, ticket_secret, ticket_url,
     order_imported_at&.strftime("%F %T"),
     updated_at.strftime("%F %T")]
  end

  protected

  def shirt_count_positive_when_size_given
    errors.add('T-Shirts', 'Die Anzahl muss größer 0 sein, wenn eine Größe ausgewählt wurde') if number_of_shirts.blank? && !shirt_size.blank?
  end

end
