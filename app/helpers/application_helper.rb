require 'kramdown'

module ApplicationHelper

  def convert_markdown(text)
    markdown = Kramdown::Document.new(text, :auto_ids => false)
    return raw markdown.to_html
  end

  def to_j_n(value)
    if value then 'Ja' else 'Nein' end
  end

  def user_is_admin?
    user_signed_in? && current_user.is_admin?
  end

end
