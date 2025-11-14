class Avo::Resources::AccommodationType < Avo::BaseResource
  self.title = :name
  self.includes = [:accommodations]

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
      help: "Accommodation type name (e.g., Hotel, Camping, Guest House)"
    field :description, as: :textarea,
      help: "Description of this accommodation type"
    field :size, as: :number,
      help: "Maximum capacity or size"

    # Statistics (computed)
    field :accommodations_count, as: :number, hide_on: [:edit, :new] do
      record.accommodations.count
    end

    # Relationships
    field :accommodations, as: :has_many,
      help: "Accommodations of this type"

    # Timestamps
    field :created_at, as: :date_time, hide_on: [:new, :edit, :index]
    field :updated_at, as: :date_time, hide_on: [:new, :edit, :index]
  end
end
