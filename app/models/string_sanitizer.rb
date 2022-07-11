# coding: utf-8
class StringSanitizer
  def self.sanitize_encoding(string)
    return string unless string.respond_to? :gsub
    return '' if string.blank?

    string.gsub(/[–—´`…‘’‛“”„‟Şş™]/,
                '–' => '-',
                '—' => '-',
                '´' => '\'',
                '`' => '\'',
                '…' => '...',
                '‘' => '\'',
                '’' => '\'',
                '‛' => '\'',
                '“' => '"',
                '”' => '"',
                '„' => '"',
                '‟' => '"',
                'Ş' => "S",
                'ş' => "s",
                '™' => '(TM)'
    )
  end
end