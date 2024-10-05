# frozen_string_literal: true

# dummy class for form
class Vote < ApplicationRecord
  @@PUBLIC = 'public'
  @@ATTENDEES = 'attendees'
  class << self
    def PUBLIC_VOTES
      @@PUBLIC
    end
    def ATTENDEES_VOTES
      @@ATTENDEES
    end
  end

 end
