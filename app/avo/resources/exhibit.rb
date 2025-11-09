class Avo::Resources::Exhibit < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :attendance_id, as: :number
    field :name, as: :text
    field :description, as: :textarea
    field :url, as: :text
    field :size_studs, as: :text
    field :size, as: :text
    field :value, as: :number
    field :building_hours, as: :text
    field :brick_count, as: :number
    field :needs_power_supply, as: :boolean
    field :needs_transportation, as: :boolean
    field :is_installation, as: :boolean
    field :is_part_of_installation, as: :boolean
    field :installation_exhibit_id, as: :number
    field :remarks, as: :textarea
    field :size_x, as: :number
    field :size_y, as: :number
    field :size_z, as: :number
    field :unit_id, as: :number
    field :size_x_meter, as: :number
    field :size_y_meter, as: :number
    field :size_z_meter, as: :number
    field :former_exhibit_id, as: :number
    field :is_approved, as: :boolean
    field :size_x_centimeter, as: :number
    field :size_y_centimeter, as: :number
    field :size_z_centimeter, as: :number
    field :platform, as: :number
    field :position, as: :number
    field :cached_scoped_public_votes_total, as: :number
    field :cached_scoped_public_votes_score, as: :number
    field :cached_scoped_public_votes_up, as: :number
    field :cached_scoped_public_votes_down, as: :number
    field :cached_weighted_public_score, as: :number
    field :cached_weighted_public_total, as: :number
    field :cached_weighted_public_average, as: :number
    field :cached_scoped_attendees_votes_total, as: :number
    field :cached_scoped_attendees_votes_score, as: :number
    field :cached_scoped_attendees_votes_up, as: :number
    field :cached_scoped_attendees_votes_down, as: :number
    field :cached_weighted_attendees_score, as: :number
    field :cached_weighted_attendees_total, as: :number
    field :cached_weighted_attendees_average, as: :number
    field :is_collab, as: :boolean
    field :attendance, as: :belongs_to
    field :unit, as: :belongs_to
    field :installation_parts, as: :has_many
    field :installation, as: :belongs_to
    field :subsequent_exhibits, as: :has_many
    field :former_exhibit, as: :belongs_to
    field :votes_for, as: :has_many
  end
end
