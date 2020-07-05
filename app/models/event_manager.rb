class EventManager < ActiveRecord::Base
  attr_protected :id
  belongs_to :event
  belongs_to :user
end
