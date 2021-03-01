class CreateAttendeeTypes < ActiveRecord::Migration[3.1]
  def change
    create_table :attendee_types do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
