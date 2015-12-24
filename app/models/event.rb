require 'csv'

class Event < ActiveRecord::Base
  has_many :attendances
  has_many :attendees, :through => :attendances
  has_many :accommodations, :through => :attendances
  has_many :exhibits, :through => :attendances

  default_scope order('start_date desc')

  def self.open_events
    Event.find_all_by_registration_open(true)
  end

  def number_of_attendees
    return attendees.count
  end

  def number_of_exhibits
    return exhibits.count
  end

  def installations
    return exhibits.select { |e| e.is_installation? }
  end

  def to_s
    name
  end

  def square_meters_registered
    square_meters = 0.0
    exhibits.each { |e| square_meters += e.size_in_square_meters}
    square_meters
  end

  def square_meters_approved
    square_meters = 0.0
    exhibits.each { |e| square_meters += e.size_in_square_meters if e.is_approved? }
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
    CSV.generate({ :col_sep => ';', :quote_char => '"' }) do |csv|
       csv << Attendee.csv_array_header
       self.attendees.each do |item|
          csv << item.csv_array
       end
    end
  end

  def exhibits_as_csv
    CSV.generate({ :col_sep => ';', :quote_char => '"' }) do |csv|
       csv << Exhibit.csv_array_header
       self.exhibits.each do |item|
          csv << item.csv_array
       end
    end
  end

end
