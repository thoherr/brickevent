class AddVisibleFlagToAttendeeType < ActiveRecord::Migration[4.2]
  def up
    change_table(:attendee_types) do |t|
      t.boolean :is_visible
    end
  end
  def down
    remove_column :attendee_types, :is_visible
  end
end
