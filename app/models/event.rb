class Event < ActiveRecord::Base
  has_many :participations
  
  def number_of_participants
    return participations.count
  end
  
  def number_of_exhibits
    count = 0
    participations.each do |p|
      count += p.exhibits.count
    end
    return count
  end
  
end
