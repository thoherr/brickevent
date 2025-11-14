class Avo::Resources::Lug < Avo::BaseResource
  self.title = :name
  self.includes = [:events]

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
      help: "Name of the LEGO User Group"
    field :description, as: :textarea,
      help: "LUG description and information"

    # Contact & URLs
    field :info_mail, as: :text,
      help: "Contact email for the LUG"
    field :url, as: :text,
      help: "LUG website URL"
    field :impress_url, as: :text,
      help: "URL to imprint/impressum page"

    # Branding
    field :logo_url, as: :text,
      help: "URL to LUG logo image"
    field :favicon_url, as: :text,
      help: "URL to favicon"

    # Configuration
    field :request_pattern, as: :text, hide_on: :index,
      help: "URL pattern for request matching"

    # Statistics (computed fields)
    field :events_count, as: :number, hide_on: [:edit, :new] do
      record.events.count
    end

    field :active_events_count, as: :number, hide_on: [:edit, :new],
      help: "Events with registration open" do
      record.events.where(registration_open: true).count
    end

    # Relationships
    field :events, as: :has_many

    # Timestamps
    field :created_at, as: :date_time, hide_on: [:new, :edit, :index]
    field :updated_at, as: :date_time, hide_on: [:new, :edit, :index]
  end
end
