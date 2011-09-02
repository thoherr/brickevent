class CreateAttendeeTypes < ActiveRecord::Migration
  def change
    create_table :attendee_types do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
