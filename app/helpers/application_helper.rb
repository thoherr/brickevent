require 'kramdown'

module ApplicationHelper

  def convert_markdown(text)
    markdown = Kramdown::Document.new(text, :auto_ids => false)
    return raw markdown.to_html
  end

  def to_yes_no(value)
    if value then t('yes') else t('no') end
  end

  def user_is_admin?
    user_signed_in? && current_user.is_admin?
  end

end
