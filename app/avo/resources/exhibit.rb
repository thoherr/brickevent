class Avo::Resources::Exhibit < Avo::BaseResource
  self.title = :name
  self.includes = [:attendance, :unit, :installation]

  # Enable search
  self.search = {
    query: -> {
      query.where(
        "exhibits.name LIKE ? OR exhibits.description LIKE ?",
        "%#{params[:q]}%", "%#{params[:q]}%"
      )
    }
  }

  def fields
    field :id, as: :id, link_to_record: true

    # Basic Information
    field :name, as: :text, required: true,
      help: "MOC/Exhibit name"
    field :description, as: :textarea,
      help: "Description of the exhibit"
    field :attendance, as: :belongs_to, required: true,
      searchable: true

    # Approval & Status
    field :is_approved, as: :boolean,
      help: "⭐ Approve this exhibit for display"

    # Classification
    field :is_collab, as: :boolean, hide_on: :index,
      help: "Collaboration between multiple builders"
    field :is_installation, as: :boolean, hide_on: :index,
      help: "This is an installation (grouping of exhibits)"
    field :is_part_of_installation, as: :boolean, hide_on: :index,
      help: "Part of a larger installation"
    field :installation, as: :belongs_to, hide_on: [:index, :new],
      help: "Parent installation if this is part of one"

    # Size Information
    field :unit, as: :belongs_to,
      help: "Measurement unit (studs, cm, etc.)"
    field :size_x, as: :number, hide_on: :index,
      help: "Width in specified unit"
    field :size_y, as: :number, hide_on: :index,
      help: "Depth in specified unit"
    field :size_z, as: :number, hide_on: :index,
      help: "Height in specified unit"

    # Computed Size (show only)
    field :size_in_meters, as: :text, readonly: true, hide_on: [:edit, :new, :index] do
      if record.size_x_meter && record.size_y_meter
        "#{record.size_x_meter.round(2)}m × #{record.size_y_meter.round(2)}m"
      else
        "Not calculated"
      end
    end

    field :size_square_meters, as: :number, readonly: true, hide_on: [:edit, :new],
      help: "Total footprint in m²" do
      record.size_in_square_meters.round(2)
    end

    # Build Details
    field :brick_count, as: :number, hide_on: :index,
      help: "Estimated number of bricks"
    field :building_hours, as: :number, hide_on: :index,
      help: "Time spent building"
    field :value, as: :number, hide_on: :index,
      help: "Estimated value"

    # Logistics
    field :needs_power_supply, as: :boolean, hide_on: :index,
      help: "Requires electrical outlet"
    field :needs_transportation, as: :boolean, hide_on: :index,
      help: "Needs MOC transport service"
    field :platform, as: :text, hide_on: :index,
      help: "Platform/base information"
    field :position, as: :text, hide_on: :index,
      help: "Preferred position/location"

    # External Links
    field :url, as: :text, hide_on: :index,
      help: "Link to MOC page (Rebrickable, Flickr, etc.)"

    # Voting Statistics (show only)
    field :public_votes_total, as: :number, readonly: true, hide_on: [:edit, :new, :index],
      help: "Total public votes" do
      record.cached_scoped_public_votes_total || 0
    end

    field :public_votes_score, as: :number, readonly: true, hide_on: [:edit, :new, :index],
      help: "Public vote score (up - down)" do
      record.cached_scoped_public_votes_score || 0
    end

    field :attendees_votes_total, as: :number, readonly: true, hide_on: [:edit, :new, :index],
      help: "Total attendee votes" do
      record.cached_scoped_attendees_votes_total || 0
    end

    field :attendees_votes_score, as: :number, readonly: true, hide_on: [:edit, :new, :index],
      help: "Attendee vote score (up - down)" do
      record.cached_scoped_attendees_votes_score || 0
    end

    # History/Lineage
    field :former_exhibit, as: :belongs_to, hide_on: [:index, :new],
      help: "Previous version of this exhibit from another event"

    # Additional Info
    field :remarks, as: :textarea, hide_on: :index,
      help: "Internal notes and remarks"

    # Computed Info (show only)
    field :event_title, as: :text, readonly: true, hide_on: [:edit, :new] do
      record.event_title
    end

    field :user_name, as: :text, readonly: true, hide_on: [:edit, :new] do
      record.user_name
    end

    # Relationships
    field :installation_parts, as: :has_many, hide_on: [:index, :new, :edit],
      help: "Exhibits that are part of this installation"

    # Timestamps
    field :created_at, as: :date_time, hide_on: [:new, :edit, :index]
    field :updated_at, as: :date_time, hide_on: [:new, :edit, :index]
  end
end
