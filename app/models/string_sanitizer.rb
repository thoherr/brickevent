# coding: utf-8
class StringSanitizer

  def self.sanitize_encoding(text)
    text.gsub(/[—´`]/, '—' => '-', '´' => '\'', '`' => '\'')
  end
  
end
