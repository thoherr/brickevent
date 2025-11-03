class AddIndexesToForeignKeys < ActiveRecord::Migration[8.1]
  def change
    # Critical indexes for events/show page performance
    add_index :attendances, :event_id unless index_exists?(:attendances, :event_id)
    add_index :exhibits, :attendance_id unless index_exists?(:exhibits, :attendance_id)
    add_index :attendees, :attendance_id unless index_exists?(:attendees, :attendance_id)
    add_index :accommodations, :attendance_id unless index_exists?(:accommodations, :attendance_id)

    # Other foreign key indexes for general performance
    add_index :accommodations, :accommodation_type_id unless index_exists?(:accommodations, :accommodation_type_id)
    add_index :attendees, :attendee_type_id unless index_exists?(:attendees, :attendee_type_id)
    add_index :exhibits, :unit_id unless index_exists?(:exhibits, :unit_id)
    add_index :exhibits, :installation_exhibit_id unless index_exists?(:exhibits, :installation_exhibit_id)
    add_index :exhibits, :former_exhibit_id unless index_exists?(:exhibits, :former_exhibit_id)
    add_index :event_managers, :event_id unless index_exists?(:event_managers, :event_id)
    add_index :event_managers, :user_id unless index_exists?(:event_managers, :user_id)
    add_index :events, :lug_id unless index_exists?(:events, :lug_id)
    add_index :builders, :exhibit_id unless index_exists?(:builders, :exhibit_id)
    add_index :builders, :attendee_id unless index_exists?(:builders, :attendee_id)
  end
end
