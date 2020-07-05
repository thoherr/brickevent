class Builder < ActiveRecord::Base
  attr_protected :id
  belongs_to :attendee
  belongs_to :exhibit
end
