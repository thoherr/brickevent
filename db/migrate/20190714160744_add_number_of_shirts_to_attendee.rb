class AddNumberOfShirtsToAttendee < ActiveRecord::Migration[3.1]
  def change
    add_column :attendees, :number_of_shirts, :integer
  end
end
