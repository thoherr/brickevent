# coding: utf-8
require 'kramdown'

module ApplicationHelper

  def convert_markdown(text)
    markdown = Kramdown::Document.new(text, :auto_ids => false)
    return raw markdown.to_html
  end

  def to_yes_no(value)
    if value then t('yes') else t('no') end
  end

  # Favicon of the current LUG; nothing is rendered when no favicon is configured.
  def lug_favicon_link_tag(lug)
    return nil if lug.nil? || lug.favicon_url.blank?

    favicon_link_tag lug.favicon_url
  end

  def user_is_admin?
    user_signed_in? && current_user.is_admin?
  end

  # SVG QR code of a pretix ticket secret, scannable by pretixSCAN
  def ticket_qr_code(secret)
    RQRCode::QRCode.new(secret).as_svg(module_size: 5, standalone: true, use_path: true, viewbox: true).html_safe
  end

  def is_locale_supported?(locale)
    ApplicationController.supported_locales.include? locale
  end
end
