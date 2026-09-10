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

  # Shop and Abhol-Code columns are shown while the shop is enabled for the event
  # or as soon as any listed attendee has an order (so imported tickets stay
  # visible after the order phase); otherwise the columns would only be empty.
  def show_shop_columns?(event, attendees)
    return false if event.nil? || !event.shop_configured?

    event.shop_active? || attendees.any?(&:has_order?)
  end

  # The pretix ticket secret (and its QR code) is only for admins and event managers.
  def can_see_ticket_secret?(attendee)
    return false unless user_signed_in?

    current_user.is_admin? || !!attendee.event&.is_managed_by?(current_user)
  end

  # Favicon of the current LUG; nothing is rendered when no favicon is configured.
  def lug_favicon_link_tag(lug)
    return nil if lug.nil? || lug.favicon_url.blank?

    favicon_link_tag lug.favicon_url
  end

  # Summary line for a collapsible table: shows "show" or "hide" depending on the
  # open state of the surrounding <details> element (switched via CSS, no JS).
  def collapsible_table_summary(table, count)
    content_tag(:summary) do
      content_tag(:span, t('show_table', table: table, count: count), class: 'WhenClosed') +
        content_tag(:span, t('hide_table', table: table, count: count), class: 'WhenOpen')
    end
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
