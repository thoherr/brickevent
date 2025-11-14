class Avo::Resources::Unit < Avo::BaseResource
  self.title = :name
  self.includes = [:exhibits]

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
      help: "Unit name (e.g., Studs, Centimeters, Meters)"
    field :description, as: :textarea,
      help: "Description of this measurement unit"

    # Conversion Factor
    field :centimeter, as: :number, required: true,
      help: "Conversion factor to centimeters (e.g., 1 stud = 0.8 cm)"

    # Computed Conversion Info (show only)
    field :conversion_info, as: :text, readonly: true, hide_on: [:edit, :new, :index],
      help: "Quick conversion reference" do
      if record.centimeter
        "1 #{record.name} = #{record.centimeter} cm"
      else
        "No conversion factor set"
      end
    end

    # Statistics (computed)
    field :exhibits_count, as: :number, hide_on: [:edit, :new] do
      record.exhibits.count
    end

    field :total_square_meters, as: :number, hide_on: [:edit, :new],
      help: "Total footprint of all exhibits using this unit" do
      record.exhibits.sum(:size_square_meters).round(2)
    end

    # Relationships
    field :exhibits, as: :has_many,
      help: "Exhibits measured in this unit"

    # Timestamps
    field :created_at, as: :date_time, hide_on: [:new, :edit, :index]
    field :updated_at, as: :date_time, hide_on: [:new, :edit, :index]
  end
end
