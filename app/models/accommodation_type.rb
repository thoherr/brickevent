class AccommodationType < ActiveRecord::Base
  attr_protected :id
  has_many :accommodations

  def to_s
    "#{name}"
  end

end
