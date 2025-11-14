class Avo::Resources::User < Avo::BaseResource
  self.title = :email
  self.includes = [:attendances, :events]

  # Enable search
  self.search = {
    query: -> {
      query.where(
        "email LIKE ? OR name LIKE ? OR nickname LIKE ? OR lug LIKE ?",
        "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%"
      )
    }
  }

  def fields
    field :id, as: :id, link_to_record: true

    # Account Information
    field :email, as: :text, required: true,
      help: "User's email address (used for login)"
    field :name, as: :text, required: true,
      help: "Full name"
    field :nickname, as: :text,
      help: "Display name / nickname"

    # LUG Affiliation
    field :lug, as: :text,
      help: "LEGO User Group affiliation"

    # Contact Information
    field :phone, as: :text, hide_on: :index
    field :address, as: :textarea, hide_on: :index

    # Admin & Permissions
    field :is_admin, as: :boolean,
      help: "⚠️ Grant admin access to user"

    # Account Status
    field :confirmed_at, as: :date_time, readonly: true, hide_on: [:index, :new, :edit],
      help: "Email confirmation timestamp"
    field :confirmation_sent_at, as: :date_time, readonly: true, hide_on: [:index, :new, :edit]
    field :accept_data_storage, as: :boolean, readonly: true, hide_on: [:index, :new, :edit],
      help: "User accepted data storage policy"

    # Activity Tracking
    field :sign_in_count, as: :number, readonly: true, hide_on: [:new, :edit, :index]
    field :current_sign_in_at, as: :date_time, readonly: true, hide_on: [:new, :edit, :index]
    field :last_sign_in_at, as: :date_time, readonly: true, hide_on: [:new, :edit, :index]
    field :current_sign_in_ip, as: :text, readonly: true, hide_on: [:new, :edit, :index]
    field :last_sign_in_ip, as: :text, readonly: true, hide_on: [:new, :edit, :index]

    # Statistics
    field :attendances_count, as: :number, hide_on: [:edit, :new] do
      record.attendances.count
    end

    field :open_attendances_count, as: :number, hide_on: [:edit, :new],
      help: "Attendances for events with open registration" do
      record.open_attendances.count
    end

    field :exhibits_count, as: :number, hide_on: [:edit, :new] do
      record.exhibits.count
    end

    # Relationships
    field :attendances, as: :has_many
    field :exhibits, as: :has_many, through: :attendances
    field :event_managers, as: :has_many
    field :events, as: :has_many, through: :event_managers,
      help: "Events managed by this user"

    # Timestamps
    field :created_at, as: :date_time, hide_on: [:new, :edit, :index]
    field :updated_at, as: :date_time, hide_on: [:new, :edit, :index]
  end
end
