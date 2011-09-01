class Builder < ActiveRecord::Base
  belongs_to :attendee
  belongs_to :exhibit
end
