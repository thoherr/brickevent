# frozen_string_literal: true

# Imports the positions sheet of the pretix "Order data" export and stores
# the main order position (the row carrying the attendee's voucher) on the
# attendee: order code, position id, status, ticket secret and ticket link.
#
# Rows without a voucher (add-on positions, orders placed without voucher)
# are ignored. Rows whose voucher does not belong to an attendee of the
# given event, or whose ticket link does not point to the event's shop, are
# counted as failures. If one attendee has several rows (re-order after a
# cancellation) the active and newest one wins. Re-importing is idempotent.
class CsvOrderImport < ApplicationService
  require 'csv'

  # English pretix export headers first, German aliases as fallback.
  HEADERS = {
    order_code: ['Order code', 'Bestellcode'],
    position_id: ['Position ID', 'Positions-ID', 'Position-ID'],
    status: ['Status'],
    voucher: ['Voucher', 'Gutschein'],
    ticket_secret: ['Ticket secret', 'Ticket-Secret', 'Ticketcode'],
    ticket_url: ['Position order link', 'Bestelllink der Position', 'Link zur Position'],
    order_date: ['Order date', 'Bestelldatum'],
    order_time: ['Order time', 'Bestellzeit', 'Uhrzeit der Bestellung']
  }.freeze

  STATUS_MAP = {
    'pending' => 'pending', 'ausstehend' => 'pending', 'unbezahlt' => 'pending', 'offen' => 'pending',
    'paid' => 'paid', 'bezahlt' => 'paid',
    'expired' => 'expired', 'abgelaufen' => 'expired',
    'canceled' => 'canceled', 'cancelled' => 'canceled', 'storniert' => 'canceled'
  }.freeze

  REQUIRED = %i[order_code position_id status voucher ticket_secret].freeze

  attr_reader :event, :file

  def initialize(event, file)
    @event = event
    @file = file
  end

  def call
    result = { success_count: 0, failure_count: 0, ignore_count: 0, errors: [] }
    content = read_content
    return result.merge(errors: ['empty file']) if content.blank?

    table = CSV.parse(content, headers: true, col_sep: detect_separator(content))
    columns = map_columns(table.headers)
    missing = REQUIRED.reject { |key| columns[key] }
    return result.merge(failure_count: 1, errors: ["missing columns: #{missing.join(', ')}"]) unless missing.empty?

    candidates = Hash.new { |hash, key| hash[key] = [] }
    table.each_with_index do |row, index|
      line = index + 2
      voucher = row[columns[:voucher]].to_s.strip
      if voucher.empty?
        result[:ignore_count] += 1
        next
      end

      attendee = attendee_for(voucher)
      if attendee.nil?
        result[:failure_count] += 1
        result[:errors] << "row #{line}: unknown voucher"
        next
      end

      status = STATUS_MAP[row[columns[:status]].to_s.strip.downcase]
      if status.nil?
        result[:failure_count] += 1
        result[:errors] << "row #{line}: unknown status '#{row[columns[:status]]}'"
        next
      end

      ticket_url = columns[:ticket_url] ? row[columns[:ticket_url]].to_s.strip.presence : nil
      unless valid_ticket_url?(ticket_url)
        result[:failure_count] += 1
        result[:errors] << "row #{line}: ticket link outside shop"
        next
      end

      candidates[attendee.id] << {
        attendee: attendee,
        order_code: row[columns[:order_code]].to_s.strip,
        order_position_id: row[columns[:position_id]].to_i,
        order_status: status,
        ticket_secret: row[columns[:ticket_secret]].to_s.strip,
        ticket_url: ticket_url,
        ordered_at: ordered_at(row, columns)
      }
    end

    candidates.each_value do |rows|
      best = rows.max_by { |r| [Attendee::ACTIVE_ORDER_STATUSES.include?(r[:order_status]) ? 1 : 0, r[:ordered_at]] }
      best[:attendee].update_columns(best.except(:attendee, :ordered_at).merge(order_imported_at: Time.current))
      result[:success_count] += 1
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

  def detect_separator(content)
    first_line = content.lines.first.to_s
    first_line.count(';') > first_line.count(',') ? ';' : ','
  end

  def map_columns(headers)
    normalized = headers.compact.map { |h| [h.strip.downcase, h] }.to_h
    HEADERS.transform_values do |names|
      names.map { |n| normalized[n.downcase] }.compact.first
    end
  end

  def attendee_for(voucher)
    id = voucher[/\A(\d+)-/, 1]
    return nil if id.nil?

    attendee = Attendee.find_by(id: id)
    return nil if attendee.nil? || attendee.voucher_code.blank?
    return nil unless attendee.voucher_code.casecmp?(voucher)
    return nil unless attendee.event == event

    attendee
  end

  def valid_ticket_url?(url)
    return true if url.nil?
    return false if event.shop_base_url.blank?

    url.downcase.start_with?(event.shop_base_url.downcase)
  end

  def ordered_at(row, columns)
    date = columns[:order_date] ? row[columns[:order_date]].to_s.strip : ''
    time = columns[:order_time] ? row[columns[:order_time]].to_s.strip : ''
    "#{date} #{time}".strip
  end
end
