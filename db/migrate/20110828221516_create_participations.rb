class CreateParticipations < ActiveRecord::Migration
  def self.up
    create_table :participations do |t|
      t.integer :event_id
      t.integer :user_id
      t.integer :number_of_attendees
      t.boolean :attend_afols_evening
      t.integer :number_of_attendees_afols_evening
      t.boolean :wants_hotel_reservation
      t.string :remarks

      t.timestamps
    end
  end

  def self.down
    drop_table :participations
  end
end
