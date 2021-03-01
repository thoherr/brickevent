class AddApprovedFlagToAttendee < ActiveRecord::Migration[3.1]
  def change
    add_column :attendees, :is_approved, :boolean
  end
end
