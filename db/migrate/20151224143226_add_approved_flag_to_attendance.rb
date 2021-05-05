class AddApprovedFlagToAttendance < ActiveRecord::Migration[4.2]
  def change
    add_column :attendances, :is_approved, :boolean
  end
end
