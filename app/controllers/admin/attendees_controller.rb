module Admin 
  class AttendeesController < AdminController
    active_scaffold :attendee do |config|
    end
  end
end
