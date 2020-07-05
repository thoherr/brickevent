class Lug < ActiveRecord::Base
  attr_protected :id
  has_many :events
end
