class AddNumberOfShirtsToAttendee < ActiveRecord::Migration
  def change
    add_column :attendees, :number_of_shirts, :integer
  end
end
