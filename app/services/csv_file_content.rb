# frozen_string_literal: true

# Reads an uploaded or local CSV file as UTF-8 text. Our CSV exports are
# ISO-8859-15 (for the spreadsheet users), and re-saved files may be UTF-8
# with or without a byte order mark, so both encodings are accepted.
module CsvFileContent
  BOM = "﻿"

  # file: an uploaded file, Tempfile, Pathname or path string
  def self.read(file)
    raw = file.respond_to?(:read) ? file.read : File.read(file)
    raw = raw.dup.force_encoding(Encoding::UTF_8)
    raw = raw.encode(Encoding::UTF_8, Encoding::ISO_8859_15) unless raw.valid_encoding?
    raw.delete_prefix(BOM)
  end
end
