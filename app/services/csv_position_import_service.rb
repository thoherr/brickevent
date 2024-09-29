# frozen_string_literal: true

class CsvPositionImportService
  require 'csv'

  def call(file)
    opened_file = File.open(file)
    options = { headers: true, col_sep: ';' }
    CSV.foreach(opened_file, **options) do |row|

      exhibit = Exhibit.find(row['id'])
      exhibit.table = row['table']
      exhibit.position = row['position']
      exhibit.save!

    end
  end
end
