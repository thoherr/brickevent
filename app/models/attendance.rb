class Attendance < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  has_many :attendees
  has_many :accommodations
  has_many :exhibits

  validates_uniqueness_of :event_id, :scope => :user_id

  def create_user_as_first_attendee
    if user
      new_attendee = Attendee.new(:attendance => self, :attendee_type => AttendeeType.find_by_name('Aussteller'), :name => user.name, :lug => user.lug, :nickname => user.nickname, :email => user.email, :afols_event => true)
      attendees << new_attendee
    end
  end

  def event_installations
    return event.installations if event
    return []
  end

  def event_title
    return event.title if event
    return "NO EVENT"
  end

  def user_name
    return user.name if user
    return "NO USER"
  end

  def transportation_count
    translist = exhibits.select { |e| e.needs_transportation? }
    return translist.length
  end

  def to_s
    "#{user.to_s} @ #{event.to_s}"
  end

end
