class AddTicketToAttendees < ActiveRecord::Migration[3.1]
  def change
    add_column :attendees, :needs_ticket, :boolean, :default => true
  end
end
