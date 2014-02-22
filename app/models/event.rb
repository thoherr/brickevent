require 'csv'

class Event < ActiveRecord::Base
  has_many :attendances
  has_many :attendees, :through => :attendances
  has_many :accommodations, :through => :attendances
  has_many :exhibits, :through => :attendances

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
