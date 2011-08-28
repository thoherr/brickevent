class User < ActiveRecord::Base
  has_many :registrations
end
