# frozen_string_literal: true

class CsvExhibitImport < ApplicationService
  require 'csv'

  attr_reader :event, :file

  def initialize(event, file)
    @event = event
    @file = file
  end

  def call
    ignore_count = 0;
    success_count = 0;
    failure_count = 0
    errors = []
    opened_file = File.open(Rails.root.join('tmp', @file))
    options = { headers: true, col_sep: ';' }
    CSV.foreach(opened_file, **options) do |row|

      if row['ID'] .present? and row['ID'].to_i > 0

        exhibit = Exhibit.find_by(id: row['ID'])
        if not exhibit or @event != exhibit.event
          failure_count += 1
          errors << row['ID']
          next
        end

        exhibit.is_approved = row['Bestätigt'] if row['Bestätigt'].present?
        exhibit.name = row['MOC'] if row['MOC'].present?
        exhibit.platform = row['Tisch'] if row['Tisch'].present?
        exhibit.position = row['Position'] if row['Position'].present?
        if exhibit.save!
          success_count += 1;
        else
          failure_count += 1;
          errors << row['ID']
        end

      else
        ignore_count += 1;
      end
    end
    { success_count: success_count, failure_count: failure_count,
      errors: errors, ignore_count: ignore_count }
  end
end
