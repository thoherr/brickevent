class AddPerformanceIndexes < ActiveRecord::Migration[8.1]
  def change
    # Events table indexes
    # Index for event listing query: where("lug_id = ? and (registration_open = ? or visible = ?)")
    add_index :events, [:lug_id, :registration_open, :visible],
              name: 'index_events_on_lug_and_registration_and_visibility'
    # Index for default_scope ordering by start_date DESC
    add_index :events, :start_date

    # Visitors table indexes
    # Index for session lookup: Visitor.find_by(session_id: session_id)
    add_index :visitors, :session_id, unique: true

    # AttendeeTypes table indexes
    # Index for name lookup: AttendeeType.find_by_name('Aussteller')
    add_index :attendee_types, :name

    # Exhibits table indexes
    # Indexes for commonly filtered boolean fields
    add_index :exhibits, :is_approved
    add_index :exhibits, :is_collab
    add_index :exhibits, :is_installation
    add_index :exhibits, :is_part_of_installation

    # Attendees table indexes
    # Index for approval filtering
    add_index :attendees, :is_approved
  end
end
