# frozen_string_literal: true

# Imports attendee master data from a CSV file with the same columns as the
# attendee export (semicolon separated): rows are matched by "ID", and the
# columns Vorname, Nachname, EMail, LUG, Nickname, Bemerkungen and Bestätigt
# are updated when present. Blank cells leave the current value untouched.
# Workflow related fields (voucher, order data, options, shirts) are not
# imported.
class CsvAttendeeImport < ApplicationService
  require 'csv'

  COLUMNS = {
    'Vorname' => :given_name,
    'Nachname' => :family_name,
    'EMail' => :email,
    'LUG' => :lug,
    'Nickname' => :nickname,
    'Bemerkungen' => :remarks
  }.freeze

  TRUE_VALUES = %w[true 1 t yes y ja x].freeze
  FALSE_VALUES = %w[false 0 f no n nein].freeze

  attr_reader :event, :file

  def initialize(event, file)
    @event = event
    @file = file
  end

  def call
    result = { success_count: 0, failure_count: 0, ignore_count: 0, errors: [] }
    content = read_content
    return result if content.blank?

    CSV.parse(content, headers: true, col_sep: ';').each do |row|
      id = row['ID'].to_s.strip
      unless id.match?(/\A\d+\z/) && id.to_i > 0
        result[:ignore_count] += 1
        next
      end

      attendee = Attendee.find_by(id: id)
      if attendee.nil? || attendee.event != event
        result[:failure_count] += 1
        result[:errors] << id
        next
      end

      COLUMNS.each do |header, attribute|
        value = row[header]
        attendee[attribute] = value.strip if value.present?
      end

      approved = parse_boolean(row['Bestätigt'])
      attendee.is_approved = approved unless approved.nil?

      if attendee.save
        result[:success_count] += 1
      else
        result[:failure_count] += 1
        result[:errors] << id
      end
    end

    result
  end

  private

  def read_content
    raw = file.respond_to?(:read) ? file.read : File.read(file)
    raw = raw.dup.force_encoding(Encoding::UTF_8)
    raw = raw.encode(Encoding::UTF_8, Encoding::ISO_8859_15) unless raw.valid_encoding?
    raw.delete_prefix("﻿")
  end

  # nil when the cell is blank or not recognised, so the flag stays unchanged
  def parse_boolean(value)
    text = value.to_s.strip.downcase
    return true if TRUE_VALUES.include?(text)
    return false if FALSE_VALUES.include?(text)

    nil
  end
end
