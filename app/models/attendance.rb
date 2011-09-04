class Attendance < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  has_many :attendees
  has_many :accommodations
  has_many :exhibits

  def create_user_as_first_attendee
    if user
      new_attendee = Attendee.new(:attendance => self, :attendee_type => AttendeeType.find_by_name('Aussteller'), :name => user.name, :lug => user.lug, :nickname => user.nickname, :email => user.email)
      attendees << new_attendee
    end
  end

  def event_title
    return event.title if event
    return "NO EVENT"
  end
end
