class AddTicketToAttendees < ActiveRecord::Migration
  def change
    add_column :attendees, :needs_ticket, :boolean, :default => true
  end
end
