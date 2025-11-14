class Avo::Resources::EventManager < Avo::BaseResource
  self.title = :to_s
  self.includes = [:event, :user]

  # Enable search
  self.search = {
    query: -> {
      query.joins(:event, :user).where(
        "events.name LIKE ? OR users.name LIKE ? OR users.email LIKE ?",
        "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%"
      )
    }
  }

  def fields
    field :id, as: :id, link_to_record: true

    # Core Relationships
    field :event, as: :belongs_to, required: true,
      searchable: true,
      help: "Event to manage"
    field :user, as: :belongs_to, required: true,
      searchable: true,
      help: "User who can manage this event"

    # Computed Info (show only)
    field :event_name, as: :text, readonly: true, hide_on: [:edit, :new] do
      record.event&.name
    end

    field :user_name, as: :text, readonly: true, hide_on: [:edit, :new] do
      record.user&.name
    end

    field :user_email, as: :text, readonly: true, hide_on: [:edit, :new] do
      record.user&.email
    end

    # Timestamps
    field :created_at, as: :date_time, hide_on: [:new, :edit, :index]
    field :updated_at, as: :date_time, hide_on: [:new, :edit, :index]
  end
end
