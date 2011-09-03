class Attendance < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  has_many :attendees
  has_many :accommodations
  has_many :exhibits

  def create_user_as_first_attendee
    if user
      attendees << Attendee.new(:name => user.name, :lug => user.lug, :nickname => user.nickname, :email => user.email)
    end
  end

end
