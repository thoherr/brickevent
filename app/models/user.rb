class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :attendances, -> { order "created_at desc" }
  has_many :attendees, :through => :attendances
  has_many :exhibits, :through => :attendances
  has_many :accommodations, :through => :attendances
  has_many :event_managers
  has_many :events, :through => :event_managers

  validates_presence_of :email, :name
  validates_acceptance_of :accept_data_storage, :on => :create, :accept => true, :message => 'Du musst der Speicherung Deiner Daten zustimmen!'

  def attendance_for_event (event)
    attendances.each do |a|
      return a if a.event == event
    end
    nil
  end

  def attends_event? (event)
    !attendance_for_event(event).blank?
  end

  def open_attendances
    attendances.select {|att| att.event_registration_open? }
  end

  def has_open_attendances?
    ! open_attendances.empty?
  end

  def to_s
    email
  end

end
