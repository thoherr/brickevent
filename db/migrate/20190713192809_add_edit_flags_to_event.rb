class AddEditFlagsToEvent < ActiveRecord::Migration
  def change
    add_column :events, :edit_of_attendees_allowed, :boolean, :default => false
    add_column :events, :edit_of_mocs_allowed, :boolean, :default => false
  end
end
