class AddApprovedFlagToAttendance < ActiveRecord::Migration[3.1]
  def change
    add_column :attendances, :is_approved, :boolean
  end
end
