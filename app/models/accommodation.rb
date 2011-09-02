class Accommodation < ActiveRecord::Base
  belongs_to :attendance
  belongs_to :accommodation_type
end
