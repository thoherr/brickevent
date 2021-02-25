class AddOptionsToAttendees < ActiveRecord::Migration[3.1]
  def change
    add_column :attendees, :option_1, :boolean, :default => false
    add_column :attendees, :option_2, :boolean, :default => false
    add_column :attendees, :option_3, :boolean, :default => false
  end
end
