class AddNumberOfShirtsToAttendee < ActiveRecord::Migration[4.2]
  def change
    add_column :attendees, :number_of_shirts, :integer
  end
end
