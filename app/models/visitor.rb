# Anonymous exhibition visitor, represented by session
# used for voting functionality
class Visitor < ApplicationRecord

  acts_as_voter

  def self.load_or_create(session_id)
    visitor = Visitor.find_by(session_id: session_id)
    unless visitor
      visitor = Visitor.create(session_id: session_id)
      visitor.save
    end
    visitor
  end
end
