class Avo::Resources::Attendee < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :attendance_id, as: :number
    field :attendee_type_id, as: :number
    field :name, as: :text
    field :lug, as: :text
    field :nickname, as: :text
    field :email, as: :text
    field :afols_event, as: :boolean
    field :remarks, as: :textarea
    field :shirt_size, as: :text
    field :is_approved, as: :boolean
    field :needs_ticket, as: :boolean
    field :option_1, as: :boolean
    field :option_2, as: :boolean
    field :option_3, as: :boolean
    field :option_4, as: :boolean
    field :option_5, as: :boolean
    field :number_of_shirts, as: :number
    field :attendance, as: :belongs_to
    field :attendee_type, as: :belongs_to
  end
end
