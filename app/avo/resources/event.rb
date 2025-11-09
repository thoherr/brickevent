class Avo::Resources::Event < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :title, as: :text
    field :description, as: :textarea
    field :location, as: :text
    field :url, as: :text
    field :lugname, as: :text
    field :registration_open, as: :boolean
    field :start_date, as: :date
    field :end_date, as: :date
    field :remarks, as: :textarea
    field :has_event_shirt, as: :boolean
    field :has_accommodation, as: :boolean
    field :has_moc_card_service, as: :boolean
    field :logo_url, as: :text
    field :visible, as: :boolean
    field :has_moc_transport, as: :boolean
    field :lug_id, as: :number
    field :has_afols_event, as: :boolean
    field :has_tickets, as: :boolean
    field :has_option_1, as: :boolean
    field :label_option_1, as: :text
    field :has_option_2, as: :boolean
    field :label_option_2, as: :text
    field :has_option_3, as: :boolean
    field :label_option_3, as: :text
    field :additional_information, as: :textarea
    field :has_option_4, as: :boolean
    field :label_option_4, as: :text
    field :has_option_5, as: :boolean
    field :label_option_5, as: :text
    field :edit_of_attendees_allowed, as: :boolean
    field :edit_of_exhibits_allowed, as: :boolean
    field :current_voting_scope, as: :text
    field :lug, as: :belongs_to
    field :attendances, as: :has_many
    field :attendees, as: :has_many, through: :attendances
    field :accommodations, as: :has_many, through: :attendances
    field :exhibits, as: :has_many, through: :attendances
    field :event_managers, as: :has_many
    field :managers, as: :has_many, through: :event_managers
  end
end
