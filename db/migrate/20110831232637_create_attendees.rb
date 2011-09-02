class CreateAttendees < ActiveRecord::Migration
  def change
    create_table :attendees do |t|
      t.integer :user_id
      t.integer :event_id
      t.string :name
      t.string :lug
      t.string :nickname
      t.boolean :afols_event
      t.string :remarks

      t.timestamps
    end
  end
end
