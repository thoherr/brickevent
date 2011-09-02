class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :lug, :nickname, :address, :phone

  has_many :attendees
  has_many :exhibits

  def is_registered_for_event? (event)
    attendees.each do |a|
      return true if a.event == event && a.user == self
    end
    return false
  end

end
