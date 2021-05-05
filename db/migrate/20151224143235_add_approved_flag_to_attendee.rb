class AddApprovedFlagToAttendee < ActiveRecord::Migration[4.2]
  def change
    add_column :attendees, :is_approved, :boolean
  end
end
