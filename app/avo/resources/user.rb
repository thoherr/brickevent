class Avo::Resources::User < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :email, as: :text
    field :sign_in_count, as: :number
    field :current_sign_in_at, as: :date_time
    field :last_sign_in_at, as: :date_time
    field :current_sign_in_ip, as: :text
    field :last_sign_in_ip, as: :text
    field :name, as: :text
    field :lug, as: :text
    field :nickname, as: :text
    field :address, as: :text
    field :phone, as: :text
    field :is_admin, as: :boolean
    field :confirmation_token, as: :text
    field :confirmed_at, as: :date_time
    field :confirmation_sent_at, as: :date_time
    field :accept_data_storage, as: :boolean
    field :unconfirmed_email, as: :text
    field :attendances, as: :has_many
    field :attendees, as: :has_many, through: :attendances
    field :exhibits, as: :has_many, through: :attendances
    field :accommodations, as: :has_many, through: :attendances
    field :event_managers, as: :has_many
    field :events, as: :has_many, through: :event_managers
  end
end
