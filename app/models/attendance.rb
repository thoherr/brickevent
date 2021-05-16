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
    translist = exhibits.select { |e| e.needs_transportation? }
    translist.length
  end

  def contains_version_of(exhibit)
    exhibits.any? { |e| e.is_version_of?(exhibit) }
  end

  def add_former_exhibit!(exhibit)
    new_exhibit = exhibit.copy_for_new_attendance
    self.exhibits << new_exhibit
  end

  def copy_exhibits!(other_attendance)
    if other_attendance.exhibits
      other_attendance.exhibits.each do |exhibit|
        if exhibit.is_latest?
          self.add_former_exhibit! exhibit
        end
      end
      self
    else
      nil
    end
  end

  def to_s
    "#{user&.name} @ #{event&.to_s}"
  end

end
