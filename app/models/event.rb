class Event < ActiveRecord::Base
  has_many :attendees
  has_many :exhibits
  
  def number_of_attendees
    return attendees.count
  end
  
  def number_of_exhibits
    return exhibits.count
  end

end
