class AddAttendeeShirtSize < ActiveRecord::Migration[3.1]
  def up
    change_table(:attendees) do |t|
      t.string :shirt_size
    end
  end

  def down
    remove_column :attendees, :shirt_size
  end
end
