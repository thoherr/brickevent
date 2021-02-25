class AccommodationType < ApplicationRecord
  has_many :accommodations

  def to_s
    "#{name}"
  end

end
