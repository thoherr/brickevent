class EventManager < ApplicationRecord
  belongs_to :event
  belongs_to :user

  def to_s
    "#{user&.name} @ #{event&.to_s}"
  end
end
