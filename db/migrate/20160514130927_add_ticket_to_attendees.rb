class AddTicketToAttendees < ActiveRecord::Migration[4.2]
  def change
    add_column :attendees, :needs_ticket, :boolean, :default => true
  end
end
