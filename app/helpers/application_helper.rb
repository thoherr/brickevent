require 'kramdown'

module ApplicationHelper

  def convert_markdown(text)
    markdown = Kramdown::Document.new(text, :auto_ids => false)
    return raw markdown.to_html
  end

  def to_j_n(value)
    if value then 'Ja' else 'Nein' end
  end

end
