class Avo::Resources::Event < Avo::BaseResource
  self.title = :name
  self.includes = [:lug, :attendances, :exhibits, :event_managers]

  # Enable search
  self.search = {
    query: -> {
      query.where(
        "name LIKE ? OR title LIKE ? OR location LIKE ?",
        "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%"
      )
    }
  }

  def fields
    field :id, as: :id, link_to_record: true

    # Basic Information Panel
    field :name, as: :text, required: true,
      help: "Internal name for the event"
    field :title, as: :text, required: true,
      help: "Public title displayed to users"
    field :description, as: :textarea,
      help: "Event description shown on registration page"

    # Event Details
    field :lug, as: :belongs_to, required: true
    field :location, as: :text, required: true
    field :start_date, as: :date, required: true
    field :end_date, as: :date, required: true

    # URLs and Branding
    field :url, as: :text,
      help: "Event website URL"
    field :logo_url, as: :text,
      help: "URL to event logo image"

    # Registration Settings Panel (tab or panel)
    field :registration_open, as: :boolean,
      help: "Allow new registrations"
    field :visible, as: :boolean,
      help: "Show event in public listing"
    field :edit_of_attendees_allowed, as: :boolean
    field :edit_of_exhibits_allowed, as: :boolean

    # Feature Flags
    field :has_tickets, as: :boolean,
      help: "Enable ticket management"
    field :has_afols_event, as: :boolean,
      help: "Has AFOLs evening event"
    field :has_event_shirt, as: :boolean
    field :has_accommodation, as: :boolean
    field :has_moc_transport, as: :boolean,
      help: "Enable MOC transport coordination"
    field :has_moc_card_service, as: :boolean

    # Custom Options
    field :has_option_1, as: :boolean, hide_on: :index
    field :label_option_1, as: :text, hide_on: :index
    field :has_option_2, as: :boolean, hide_on: :index
    field :label_option_2, as: :text, hide_on: :index
    field :has_option_3, as: :boolean, hide_on: :index
    field :label_option_3, as: :text, hide_on: :index
    field :has_option_4, as: :boolean, hide_on: :index
    field :label_option_4, as: :text, hide_on: :index
    field :has_option_5, as: :boolean, hide_on: :index
    field :label_option_5, as: :text, hide_on: :index

    # Voting
    field :current_voting_scope, as: :text, hide_on: :index,
      help: "Current voting period identifier"

    # Additional Information
    field :remarks, as: :textarea, hide_on: :index
    field :additional_information, as: :textarea, hide_on: :index

    # Statistics (computed fields - show only)
    field :attendees_count, as: :number, hide_on: [:edit, :new] do
      record.attendances.count
    end

    field :approved_attendees_count, as: :number, hide_on: [:edit, :new] do
      record.approved_attendees.count
    end

    field :exhibits_count, as: :number, hide_on: [:edit, :new] do
      record.exhibits.count
    end

    field :approved_exhibits_count, as: :number, hide_on: [:edit, :new] do
      record.approved_exhibits.count
    end

    field :total_exhibit_size_sqm, as: :number, hide_on: [:edit, :new],
      help: "Total exhibit size in square meters" do
      record.size_square_meters_approved.round(2)
    end

    # Relationships
    field :attendances, as: :has_many
    field :attendees, as: :has_many, through: :attendances
    field :exhibits, as: :has_many, through: :attendances
    field :event_managers, as: :has_many

    # Timestamps
    field :created_at, as: :date_time, hide_on: [:new, :edit, :index]
    field :updated_at, as: :date_time, hide_on: [:new, :edit, :index]
  end
end
