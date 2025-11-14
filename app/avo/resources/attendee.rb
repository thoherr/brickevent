class Avo::Resources::Attendee < Avo::BaseResource
  self.title = :name
  self.includes = [:attendance, :attendee_type]

  # Enable search
  self.search = {
    query: -> {
      query.where(
        "attendees.name LIKE ? OR attendees.email LIKE ? OR attendees.nickname LIKE ? OR attendees.lug LIKE ?",
        "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%"
      )
    }
  }

  def fields
    field :id, as: :id, link_to_record: true

    # Core Information
    field :name, as: :text, required: true,
      help: "Attendee's full name"
    field :attendance, as: :belongs_to, required: true,
      searchable: true
    field :attendee_type, as: :belongs_to, required: true,
      help: "Type: Exhibitor, Visitor, Staff, etc."

    # Contact & Identity
    field :email, as: :text, hide_on: :index,
      help: "Optional - overrides user's email if provided"
    field :lug, as: :text,
      help: "LEGO User Group affiliation"
    field :nickname, as: :text, hide_on: :index,
      help: "Display name / nickname"

    # Approval
    field :is_approved, as: :boolean,
      help: "⭐ Approve this attendee"

    # Event Participation
    field :afols_event, as: :boolean, hide_on: :index,
      help: "Attending AFOLs evening event"
    field :needs_ticket, as: :boolean, hide_on: :index,
      help: "Requires entrance ticket"

    # Event Shirts
    field :number_of_shirts, as: :number, hide_on: :index,
      help: "Number of event shirts requested"
    field :shirt_size, as: :select, hide_on: :index,
      options: ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'],
      placeholder: "Select size"

    # Custom Options (event-specific)
    field :option_1, as: :text, hide_on: [:index, :show] do
      # Only show if event has this option enabled
      record.attendance&.event&.has_option_1
    end
    field :option_2, as: :text, hide_on: [:index, :show] do
      record.attendance&.event&.has_option_2
    end
    field :option_3, as: :text, hide_on: [:index, :show] do
      record.attendance&.event&.has_option_3
    end
    field :option_4, as: :text, hide_on: [:index, :show] do
      record.attendance&.event&.has_option_4
    end
    field :option_5, as: :text, hide_on: [:index, :show] do
      record.attendance&.event&.has_option_5
    end

    # Additional Info
    field :remarks, as: :textarea, hide_on: :index,
      help: "Special requests or notes"

    # Computed Info (show only)
    field :event_title, as: :text, readonly: true, hide_on: [:edit, :new] do
      record.event_title
    end

    field :attendee_email, as: :text, readonly: true, hide_on: [:edit, :new, :index],
      help: "Effective email (from attendee or user)" do
      record.attendee_email
    end

    field :phone, as: :text, readonly: true, hide_on: [:edit, :new, :index] do
      record.phone
    end

    # Timestamps
    field :created_at, as: :date_time, hide_on: [:new, :edit, :index]
    field :updated_at, as: :date_time, hide_on: [:new, :edit, :index]
  end
end
