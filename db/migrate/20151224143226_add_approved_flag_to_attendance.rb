class AddApprovedFlagToAttendance < ActiveRecord::Migration
  def change
    add_column :attendances, :is_approved, :boolean
  end
end
