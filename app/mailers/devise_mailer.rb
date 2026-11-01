# frozen_string_literal: true

# Devise mails link to the LUG domain of the request that triggered them.
class DeviseMailer < Devise::Mailer
  default template_path: 'devise/mailer'

  def default_url_options
    host = Current.host_with_port
    host.present? ? super.merge(host: host) : super
  end
end
