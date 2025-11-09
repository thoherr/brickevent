class Avo::Resources::Lug < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :description, as: :textarea
    field :url, as: :text
    field :logo_url, as: :text
    field :info_mail, as: :text
    field :request_pattern, as: :text
    field :impress_url, as: :text
    field :favicon_url, as: :text
    field :events, as: :has_many
  end
end
