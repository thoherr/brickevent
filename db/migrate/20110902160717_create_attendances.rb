class CreateAttendances < ActiveRecord::Migration[4.2]
  def change
    create_table :attendances do |t|
      t.integer :user_id
      t.integer :event_id

      t.timestamps
    end

    add_index :attendances, [:user_id, :event_id], :unique => true

  end
end
