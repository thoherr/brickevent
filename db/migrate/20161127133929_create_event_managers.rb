class CreateEventManagers < ActiveRecord::Migration[3.1]
  def change
    create_table :event_managers do |t|
      t.integer :event_id
      t.integer :user_id

      t.timestamps
    end
  end
end
