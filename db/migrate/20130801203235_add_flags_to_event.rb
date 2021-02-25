class AddFlagsToEvent < ActiveRecord::Migration[3.1]
  def up
    change_table(:events) do |t|
      t.boolean :has_event_shirt
      t.boolean :has_accommodation
    end
  end
  def down
    remove_column :events, :has_event_shirt
    remove_column :events, :has_accommodation
  end
end
