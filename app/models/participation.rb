class Participation < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  has_many :exhibits

  def to_label
    "#{user.to_label} @ #{event.name}"
  end

end
