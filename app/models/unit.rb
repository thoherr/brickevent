class Unit < ActiveRecord::Base
  attr_protected :id
  has_many :exhibits
end
