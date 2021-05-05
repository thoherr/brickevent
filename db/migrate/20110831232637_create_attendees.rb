class CreateAttendees < ActiveRecord::Migration[4.2]
  def change
    create_table :attendees do |t|
      t.integer :attendance_id
      t.integer :attendee_type_id
      t.string :name
      t.string :lug
      t.string :nickname
      t.string :email
      t.boolean :afols_event
      t.string :remarks

      t.timestamps
    end
  end
end
