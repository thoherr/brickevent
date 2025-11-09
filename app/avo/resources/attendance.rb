class Avo::Resources::Attendance < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :user_id, as: :number
    field :event_id, as: :number
    field :is_approved, as: :boolean
    field :user, as: :belongs_to
    field :event, as: :belongs_to
    field :attendees, as: :has_many
    field :accommodations, as: :has_many
    field :exhibits, as: :has_many
  end
end
