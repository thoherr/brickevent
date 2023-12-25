class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :event
  has_many :attendees
  has_many :accommodations
  has_many :exhibits

  after_create :create_user_as_first_attendee

  before_update :approve_dependents, :if => :is_approved_changed?

  validates_uniqueness_of :event_id, :scope => :user_id

  def approve_dependents
    self.attendees.each { |a| a.is_approved = is_approved; a.save }
    self.exhibits.each { |e| e.is_approved = is_approved; e.save }
  end

  def create_user_as_first_attendee
    if user
      new_attendee = Attendee.new(:attendance => self, :attendee_type => AttendeeType.find_by_name('Aussteller'), :name => user.name, :lug => user.lug, :nickname => user.nickname, :email => user.email, :afols_event => true)
      attendees << new_attendee
    end
  end

  def other_open_attendances
    user&.open_attendances.select { |att| att != self } || []
  end

  def other_attendances_with_exhibits
    user&.attendances.select { |att| att != self && att.exhibits.count > 0 } || []
  end

  def has_former_exhibits?
    !other_attendances_with_exhibits.empty?
  end

  def is_managed_by?(user)
    self.user == user || event&.is_managed_by?(user)
  end

  def event_registration_open?
    event&.registration_open?
  end

  def event_installations
    event&.installations || []
  end

  def event_title
    event&.title || "NO EVENT"
  end

  def user_name
    user&.name || "NO USER"
  end

  def user_email
    user&.email || "NO USER"
  end

  def user_lug
    user&.lug || "NO USER"
  end

  def transportation_count
    exhibits.select { |e| e.needs_transportation? }.length
  end

  def contains_version_of(exhibit)
    exhibits.any? { |e| e.is_version_of?(exhibit) }
  end

  def add_former_exhibit!(exhibit)
    self.exhibits << exhibit.copy_for_new_attendance
  end

  def copy_exhibits!(other_attendance)
    return unless other_attendance.exhibits

    other_attendance.exhibits.filter(&:is_latest?).each do |exhibit|
      add_former_exhibit!(exhibit)
    end

    self
  end

  def to_s
    "#{user&.name} @ #{event&.to_s}"
  end

end
