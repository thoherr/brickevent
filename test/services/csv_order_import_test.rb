require "test_helper"

class CsvOrderImportTest < ActiveSupport::TestCase
  HEADER = "Order code,Position ID,Status,Order date,Order time,Product,Voucher,Ticket secret,Add-on to position ID,Position order link\n"
  SHOP = "https://pretix.example.com/lug1/ev3/"

  def setup
    @event = events(:three)
    @attendee = attendees(:one)
    @voucher = @attendee.voucher_code
  end

  test "imports the main position and ignores add-on rows" do
    csv = HEADER +
          "QX7YP,1,paid,2026-05-01,10:15:00,Teilnahme,#{@voucher},secret-main,,#{SHOP}ticket/QX7YP/1/abc/\n" +
          "QX7YP,2,paid,2026-05-01,10:15:00,T-Shirt,,secret-addon,1,#{SHOP}ticket/QX7YP/2/def/\n"

    result = run_import(csv)

    assert_equal 1, result[:success_count]
    assert_equal 1, result[:ignore_count]
    assert_equal 0, result[:failure_count]
    assert_empty result[:errors]
    @attendee.reload
    assert_equal "QX7YP", @attendee.order_code
    assert_equal 1, @attendee.order_position_id
    assert_equal "paid", @attendee.order_status
    assert_equal "secret-main", @attendee.ticket_secret
    assert_equal "#{SHOP}ticket/QX7YP/1/abc/", @attendee.ticket_url
    assert_not_nil @attendee.order_imported_at
    assert @attendee.show_ticket?
    assert_not @attendee.show_order_link?
  end

  test "matches the voucher case-insensitively" do
    csv = HEADER + "QX7YP,1,paid,2026-05-01,10:15:00,Teilnahme,#{@voucher.downcase},secret-main,,\n"

    result = run_import(csv)

    assert_equal 1, result[:success_count]
    assert_equal "QX7YP", @attendee.reload.order_code
    assert_nil @attendee.ticket_url
  end

  test "accepts semicolon separated files with German headers" do
    csv = "Bestellcode;Positions-ID;Status;Gutschein;Ticket-Secret\n" +
          "QX7YP;1;bezahlt;#{@voucher};secret-main\n"

    result = run_import(csv)

    assert_equal 1, result[:success_count]
    assert_equal "paid", @attendee.reload.order_status
  end

  test "prefers the active and newest order when an attendee has several rows" do
    csv = HEADER +
          "OLD01,1,canceled,2026-05-01,10:00:00,Teilnahme,#{@voucher},secret-old,,\n" +
          "NEW02,1,pending,2026-05-03,10:00:00,Teilnahme,#{@voucher},secret-new,,\n" +
          "MID03,1,canceled,2026-05-02,10:00:00,Teilnahme,#{@voucher},secret-mid,,\n"

    result = run_import(csv)

    assert_equal 1, result[:success_count]
    @attendee.reload
    assert_equal "NEW02", @attendee.order_code
    assert_equal "pending", @attendee.order_status
    assert @attendee.order_pending?
    assert_not @attendee.show_ticket?
    assert_not @attendee.show_order_link?
  end

  test "a canceled order frees the order link again" do
    csv = HEADER + "OLD01,1,canceled,2026-05-01,10:00:00,Teilnahme,#{@voucher},secret-old,,\n"

    run_import(csv)

    @attendee.reload
    assert_equal "canceled", @attendee.order_status
    assert_not @attendee.has_order?
    assert @attendee.show_order_link?
  end

  test "fails for unknown vouchers and vouchers of other events" do
    other = attendees(:four) # belongs to event two
    csv = HEADER +
          "AAAAA,1,paid,2026-05-01,10:00:00,Teilnahme,999-0F4C4A3E-1F2B-4C3D-8E9F-000000000999,s1,,\n" +
          "BBBBB,1,paid,2026-05-01,10:00:00,Teilnahme,#{other.voucher_code},s2,,\n" +
          "CCCCC,1,paid,2026-05-01,10:00:00,Teilnahme,101-WRONG-UUID,s3,,\n" +
          "DDDDD,1,paid,2026-05-01,10:00:00,Teilnahme,not-a-voucher,s4,,\n"

    result = run_import(csv)

    assert_equal 0, result[:success_count]
    assert_equal 4, result[:failure_count]
    assert_equal ["row 2: unknown voucher", "row 3: unknown voucher", "row 4: unknown voucher", "row 5: unknown voucher"], result[:errors]
    assert_nil other.reload.order_code
  end

  test "rejects ticket links outside the shop" do
    csv = HEADER + "QX7YP,1,paid,2026-05-01,10:00:00,Teilnahme,#{@voucher},secret,,https://evil.example.com/ticket/\n"

    result = run_import(csv)

    assert_equal 1, result[:failure_count]
    assert_equal ["row 2: ticket link outside shop"], result[:errors]
    assert_nil @attendee.reload.order_code
  end

  test "rejects unknown status values" do
    csv = HEADER + "QX7YP,1,weird,2026-05-01,10:00:00,Teilnahme,#{@voucher},secret,,\n"

    result = run_import(csv)

    assert_equal 1, result[:failure_count]
    assert_equal ["row 2: unknown status 'weird'"], result[:errors]
  end

  test "reports missing required columns" do
    csv = "Order code,Voucher\nQX7YP,#{@voucher}\n"

    result = run_import(csv)

    assert_equal 1, result[:failure_count]
    assert_equal ["missing columns: position_id, status, ticket_secret"], result[:errors]
  end

  test "handles empty files and a UTF-8 BOM" do
    assert_equal ['empty file'], run_import("")[:errors]

    csv = "﻿" + HEADER + "QX7YP,1,paid,2026-05-01,10:00:00,Teilnahme,#{@voucher},secret,,\n"
    assert_equal 1, run_import(csv)[:success_count]
  end

  test "re-import is idempotent" do
    csv = HEADER + "QX7YP,1,paid,2026-05-01,10:00:00,Teilnahme,#{@voucher},secret,,\n"

    run_import(csv)
    first = @attendee.reload.attributes.except('order_imported_at')
    run_import(csv)
    second = @attendee.reload.attributes.except('order_imported_at')

    assert_equal first, second
  end

  private

  def run_import(content)
    file = Tempfile.new(['orders', '.csv'])
    file.write(content)
    file.rewind
    CsvOrderImport.call(@event, file)
  ensure
    file.close
    file.unlink
  end
end
