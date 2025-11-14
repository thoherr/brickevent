class Avo::Resources::AttendeeType < Avo::BaseResource
  self.title = :name
  self.includes = [:attendees]

  # Enable search
  self.search = {
    query: -> {
      query.where(
        "name LIKE ? OR description LIKE ?",
        "%#{params[:q]}%", "%#{params[:q]}%"
      )
    }
  }

  def fields
    field :id, as: :id, link_to_record: true

    # Basic Information
    field :name, as: :text, required: true,
      help: "Attendee type name (e.g., Exhibitor, Visitor, Staff, VIP)"
    field :description, as: :textarea,
      help: "Description of this attendee category"

    # Visibility
    field :is_visible, as: :boolean,
      help: "Show this attendee type in public registration forms"

    # Statistics (computed)
    field :attendees_count, as: :number, hide_on: [:edit, :new] do
      record.attendees.count
    end

    field :active_attendees_count, as: :number, hide_on: [:edit, :new],
      help: "Approved attendees of this type" do
      record.attendees.where(is_approved: true).count
    end

    # Relationships
    field :attendees, as: :has_many,
      help: "Attendees of this type"

    # Timestamps
    field :created_at, as: :date_time, hide_on: [:new, :edit, :index]
    field :updated_at, as: :date_time, hide_on: [:new, :edit, :index]
  end
end
