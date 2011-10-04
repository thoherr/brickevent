class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :lug, :nickname, :address, :phone

  has_many :attendances
  has_many :attendees, :through => :attendances
  has_many :exhibits, :through => :attendances
  has_many :accommodations, :through => :attendances

  validates_presence_of :name

  def attendance_for_event (event)
    attendances.each do |a|
      return a if a.event == event
    end
    return nil
  end

  def attends_event? (event)
    return !attendance_for_event(event).blank?
  end

  def to_s
    email
  end

end
