# coding: utf-8
class StringSanitizer

  def self.sanitize_encoding(text)
    return '' if text.blank?
    text.gsub(/[—´`]/, '—' => '-', '´' => '\'', '`' => '\'')
  end
  
end
