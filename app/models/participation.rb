class Participation < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  has_many :exhibits
end
