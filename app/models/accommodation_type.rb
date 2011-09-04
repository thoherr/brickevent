class AccommodationType < ActiveRecord::Base
  has_many :accommodations

  def to_s
    "#{name}"
  end

end
