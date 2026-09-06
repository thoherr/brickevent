class EventManager < ApplicationRecord
  belongs_to :event
  belongs_to :user

  def to_s
    "#{user&.full_name} @ #{event&.to_s}"
  end
end
