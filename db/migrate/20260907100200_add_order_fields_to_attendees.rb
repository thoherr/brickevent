# Data of the attendee's main order position in the pretix shop, imported
# from the pretix order export (or later via the API).
class AddOrderFieldsToAttendees < ActiveRecord::Migration[8.1]
  def change
    add_column :attendees, :order_code, :string
    add_column :attendees, :order_position_id, :integer
    add_column :attendees, :order_status, :string
    add_column :attendees, :ticket_secret, :string
    add_column :attendees, :ticket_url, :string
    add_column :attendees, :order_imported_at, :datetime
  end
end
