class Unit < ApplicationRecord
  has_many :exhibits

  def factor_to_cm # compatibility for DB migration history
    return centimeter if respond_to? :centimeter
    factor * 100.0 # old factor converted to meters
  end
end
