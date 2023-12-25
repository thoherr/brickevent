class Accommodation < ApplicationRecord
  belongs_to :attendance
  belongs_to :accommodation_type

  validates_presence_of :attendance
  validates_presence_of :accommodation_type
  validates_presence_of :count

  def is_managed_by?(user)
    attendance&.is_managed_by?(user)
  end

  def event_title
    attendance&.event_title || "NO ATTENDANCE"
  end

  def user_name
    attendance&.user_name || "NO ATTENDANCE"
  end

  def accommodation_type_name
    accommodation_type&.name || "NO ACCOMODATION_TYPE"
  end

  def to_s
    "#{count} #{accommodation_type}"
  end

end
