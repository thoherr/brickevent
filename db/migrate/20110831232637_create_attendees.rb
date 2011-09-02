class CreateAttendees < ActiveRecord::Migration
  def change
    create_table :attendees do |t|
      t.integer :attendance_id
      t.string :name
      t.string :lug
      t.string :nickname
      t.boolean :afols_event
      t.string :remarks

      t.timestamps
    end
  end
end
