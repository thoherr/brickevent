require 'csv'

class Event < ApplicationRecord
  belongs_to :lug
  has_many :attendances
  has_many :attendees, :through => :attendances
  has_many :accommodations, :through => :attendances
  has_many :exhibits, :through => :attendances
  has_many :event_managers
  has_many :managers, :source => :user, :through => :event_managers

  default_scope { order('start_date desc') }

  def self.open_events
    Event.find_all_by_registration_open(true)
    end

  def is_managed_by?(user)
    return false if user.nil?
    managers.include?(user)
  end

  def number_of_attendees
    attendees.count
  end

  def approved_attendees
    attendees.select { |a| a.is_approved? }
  end

  def number_of_approved_attendees
    approved_attendees.count
  end

  def number_of_exhibits
    exhibits.count
  end

  def installations
    exhibits.select { |e| e.is_installation? }
  end

  def tickets
    approved_attendees.select { |a| a.needs_ticket? }
  end

  def number_of_tickets
    tickets.count
  end

  def attendees_at_afols_event
    approved_attendees.select { |a| a.afols_event? }
  end

  def number_of_attendees_at_afols_event
    attendees_at_afols_event.count
  end

  def to_s
    name
  end

  def size_square_meters_registered
    square_meters = 0.0
    exhibits.each { |e| square_meters += e.size_in_square_meters}
    square_meters
  end

  def size_square_meters_approved
    square_meters = 0.0
    exhibits.each { |e| square_meters += e.size_in_square_meters if e.is_approved? }
    square_meters
  end

  def required_space_square_meters_registered
    square_meters = 0.0
    exhibits.each { |e| square_meters += e.required_space_in_square_meters unless e.is_part_of_installation? }
    square_meters
  end

  def required_space_square_meters_approved
    square_meters = 0.0
    exhibits.each { |e| square_meters += e.required_space_in_square_meters if e.is_approved? && ! e.is_part_of_installation? }
    square_meters
  end

  def attendees_mails
    mails = Set.new
    self.attendees.each do |a|
       mails << a.attendee_email unless a.attendee_email.blank?
    end
    mails.to_a.join(',')
  end

  def attendees_as_csv
    CSV.generate(**{ col_sep: ';', quote_char: '"' }) do |csv|
       csv << Attendee.csv_array_header(self)
       self.attendees.each do |item|
          csv << item.csv_array
       end
    end
  end

  def exhibits_as_csv
    CSV.generate(**{col_sep: ';', quote_char: '"' }) do |csv|
       csv << Exhibit.csv_array_header
       self.exhibits.each do |item|
          csv << item.csv_array
       end
    end
  end

end
