class Event < ActiveRecord::Base
  has_many :participations
end
