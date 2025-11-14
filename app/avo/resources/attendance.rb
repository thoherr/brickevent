class Avo::Resources::Attendance < Avo::BaseResource
  self.title = :to_s
  self.includes = [:user, :event, :attendees, :exhibits]

  # Enable search
  self.search = {
    query: -> {
      query.joins(:user, :event).where(
        "users.name LIKE ? OR users.email LIKE ? OR events.name LIKE ?",
        "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%"
      )
    }
  }

  def fields
    field :id, as: :id, link_to_record: true

    # Core Relationships
    field :user, as: :belongs_to, required: true,
      searchable: true
    field :event, as: :belongs_to, required: true,
      searchable: true

    # Approval Status
    field :is_approved, as: :boolean,
      help: "⭐ Approve this attendance (also approves all attendees and exhibits)"

    # Quick Info (computed fields - show only)
    field :user_name, as: :text, readonly: true, hide_on: [:edit, :new] do
      record.user_name
    end

    field :event_title, as: :text, readonly: true, hide_on: [:edit, :new] do
      record.event_title
    end

    # Statistics
    field :attendees_count, as: :number, hide_on: [:edit, :new] do
      record.attendees.count
    end

    field :exhibits_count, as: :number, hide_on: [:edit, :new] do
      record.exhibits.count
    end

    field :accommodations_count, as: :number, hide_on: [:edit, :new] do
      record.accommodations.count
    end

    field :transportation_count, as: :number, hide_on: [:edit, :new],
      help: "Exhibits needing transportation" do
      record.transportation_count
    end

    # Relationships
    field :attendees, as: :has_many
    field :exhibits, as: :has_many
    field :accommodations, as: :has_many

    # Timestamps
    field :created_at, as: :date_time, hide_on: [:new, :edit, :index]
    field :updated_at, as: :date_time, hide_on: [:new, :edit, :index]
  end
end
