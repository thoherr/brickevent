class AddApprovedFlagToAttendee < ActiveRecord::Migration
  def change
    add_column :attendees, :is_approved, :boolean
  end
end
