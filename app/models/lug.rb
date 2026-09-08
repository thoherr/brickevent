class Lug < ApplicationRecord
  has_many :events

  # Logo and favicon are rendered via asset helpers: a value must be an absolute
  # URL or an absolute path (e.g. "/images/lug.favicon.ico" for files in public/).
  # A bare file name would be looked up in the asset pipeline and fail there.
  ASSET_REFERENCE = %r{\A(https?://|/)\S*\z}i

  validates :logo_url, :favicon_url,
            format: { with: ASSET_REFERENCE, message: 'muss mit http(s):// oder / beginnen (z.B. /images/datei.ico)' },
            allow_blank: true
end
