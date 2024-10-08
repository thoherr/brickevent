# frozen_string_literal: true

class CsvExhibitImport < ApplicationService
  require 'csv'

  attr_reader :file

  def initialize(file)
    @file = file
  end

  def call
    opened_file = File.open(@file)
    options = { headers: true, col_sep: ';' }
    CSV.foreach(opened_file, **options) do |row|

      exhibit = Exhibit.find(row['ID'])
      exhibit.is_approved = row['Bestätigt'] if row['Bestätigt'].present?
      exhibit.name = row['MOC'] if row['MOC'].present?
      exhibit.platform = row['Tisch'] if row['Tisch'].present?
      exhibit.position = row['Position'] if row['Position'].present?
      exhibit.save!

    end
  end
end
