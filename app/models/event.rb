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

end
