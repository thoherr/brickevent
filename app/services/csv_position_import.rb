# frozen_string_literal: true

class CsvPositionImport < ApplicationService
  require 'csv'

  attr_reader :file

  def initialize(file)
    @file = file
  end

  def call
    opened_file = File.open(@file)
    options = { headers: true, col_sep: ';' }
    CSV.foreach(opened_file, **options) do |row|

      exhibit = Exhibit.find(row['id'])
      exhibit.platform = row['platform']
      exhibit.position = row['position']
      exhibit.save!

    end
  end
end
