require "test_helper"

class CsvAttendeeImportTest < ActiveSupport::TestCase
  HEADER = "ID;Bestätigt;Vorname;Nachname;LUG;Nickname;EMail;Bemerkungen\n"

  def setup
    @event = events(:three)
    @attendee = attendees(:one)
  end

  test "updates the master data fields of an attendee" do
    csv = HEADER + "#{@attendee.id};true;Änne;Müller;LUG9;Anni;anni@example.com;Neue Bemerkung\n"

    result = run_import(csv)

    assert_equal({ success_count: 1, failure_count: 0, ignore_count: 0, errors: [] }, result)
    @attendee.reload
    assert_equal "Änne", @attendee.given_name
    assert_equal "Müller", @attendee.family_name
    assert_equal "LUG9", @attendee.lug
    assert_equal "Anni", @attendee.nickname
    assert_equal "anni@example.com", @attendee.email
    assert_equal "Neue Bemerkung", @attendee.remarks
    assert @attendee.is_approved?
  end

  test "blank cells leave values unchanged" do
    before = @attendee.attributes.except('updated_at')
    csv = HEADER + "#{@attendee.id};;;;;;;\n"

    result = run_import(csv)

    assert_equal 1, result[:success_count]
    assert_equal before, @attendee.reload.attributes.except('updated_at')
  end

  test "approved flag accepts several spellings" do
    { 'nein' => false, 'ja' => true, '0' => false, '1' => true, 'false' => false, 'true' => true }.each do |text, expected|
      run_import(HEADER + "#{@attendee.id};#{text};;;;;;\n")
      assert_equal expected, @attendee.reload.is_approved?, "'#{text}' should set approved to #{expected}"
    end
  end

  test "does not touch workflow fields" do
    csv = "ID;Voucher;Bestellstatus;Ticket-Secret;Vorname\n#{@attendee.id};OTHER;paid;hacked;Änne\n"

    run_import(csv)

    @attendee.reload
    assert_equal "Änne", @attendee.given_name
    assert_equal "101-0F4C4A3E-1F2B-4C3D-8E9F-000000000101", @attendee.voucher_code
    assert_nil @attendee.order_status
    assert_nil @attendee.ticket_secret
  end

  test "ignores rows without a valid id" do
    csv = HEADER + ";true;A;B;;;;\n0;true;A;B;;;;\nabc;true;A;B;;;;\n"

    result = run_import(csv)

    assert_equal 3, result[:ignore_count]
    assert_equal 0, result[:success_count]
  end

  test "fails for unknown attendees and attendees of other events" do
    other = attendees(:four) # event two
    csv = HEADER + "999999;true;A;B;;;;\n#{other.id};true;Other;Event;;;;\n"

    result = run_import(csv)

    assert_equal 2, result[:failure_count]
    assert_equal ["999999", other.id.to_s], result[:errors]
    assert_equal "Attendee", other.reload.given_name
  end

  test "counts a failed save as failure" do
    csv = "ID;Vorname;Nachname\n#{@attendee.id};;\n"
    # size given without count fails validation (see Attendee#shirt_count_positive_when_size_given)
    @attendee.update_columns(shirt_size: 'XL', number_of_shirts: nil)

    result = run_import(csv)

    assert_equal 1, result[:failure_count]
    assert_equal [@attendee.id.to_s], result[:errors]
  end

  test "reads ISO-8859-15 files as produced by the export" do
    csv = (HEADER + "#{@attendee.id};;Änne;Müller;;;;\n").encode(Encoding::ISO_8859_15)

    result = run_import(csv)

    assert_equal 1, result[:success_count]
    assert_equal "Änne", @attendee.reload.given_name
  end

  private

  def run_import(content)
    file = Tempfile.new(['attendees', '.csv'], binmode: true)
    file.write(content)
    file.rewind
    CsvAttendeeImport.call(@event, file)
  ensure
    file.close
    file.unlink
  end
end
