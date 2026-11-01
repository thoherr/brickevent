require "test_helper"

class CsvExhibitImportTest < ActiveSupport::TestCase
  def setup
    @event = events(:one)
    @exhibit = exhibits(:one)
  end

  test "returns correct structure with all required keys" do
    csv_content = "ID;Bestätigt;MOC;Tisch;Position\n#{@exhibit.id};1;Test;5;3\n"
    file = create_temp_csv(csv_content)

    result = CsvExhibitImport.call(@event, file)

    assert result.key?(:success_count)
    assert result.key?(:failure_count)
    assert result.key?(:ignore_count)
    assert result.key?(:errors)
    assert_kind_of Integer, result[:success_count]
    assert_kind_of Integer, result[:failure_count]
    assert_kind_of Integer, result[:ignore_count]
    assert_kind_of Array, result[:errors]

    cleanup_temp_file(file)
  end

  test "ignores rows without valid ID" do
    csv_content = "ID;Bestätigt;MOC;Tisch;Position\n;1;Test;1;1\n"
    file = create_temp_csv(csv_content)

    result = CsvExhibitImport.call(@event, file)

    assert_equal 1, result[:ignore_count], "Should ignore rows without ID"

    cleanup_temp_file(file)
  end

  test "fails when exhibit ID does not exist" do
    csv_content = "ID;Bestätigt;MOC;Tisch;Position\n999999;1;Test MOC;1;1\n"
    file = create_temp_csv(csv_content)

    result = CsvExhibitImport.call(@event, file)

    assert result[:failure_count] > 0, "Should fail for non-existent ID"
    assert result[:errors].include?("999999"), "Should include failed ID in errors"

    cleanup_temp_file(file)
  end

  test "fails when exhibit belongs to different event" do
    # Create another event and exhibit
    other_event = Event.create!(
      name: "Other Event",
      title: "Other",
      start_date: Date.today,
      end_date: Date.today + 1.day,
      lug: lugs(:lugone)
    )

    other_attendance = Attendance.create!(
      user: users(:one),
      event: other_event
    )

    other_exhibit = Exhibit.create!(
      attendance: other_attendance,
      name: "Other Exhibit",
      unit: units(:one)
    )

    csv_content = "ID;Bestätigt;MOC;Tisch;Position\n#{other_exhibit.id};1;Test;1;1\n"
    file = create_temp_csv(csv_content)

    result = CsvExhibitImport.call(@event, file)

    assert result[:failure_count] > 0, "Should fail for exhibit from different event"
    assert result[:errors].include?(other_exhibit.id.to_s), "Should include failed ID"

    cleanup_temp_file(file)
  end

  test "tracks errors array correctly" do
    csv_content = "ID;Bestätigt;MOC;Tisch;Position\n999;1;Invalid;3;3\n"
    file = create_temp_csv(csv_content)

    result = CsvExhibitImport.call(@event, file)

    assert_kind_of Array, result[:errors]
    assert result[:errors].length > 0, "Should have at least one error"

    cleanup_temp_file(file)
  end

  test "ignores rows with ID less than or equal to 0" do
    csv_content = "ID;Bestätigt;MOC;Tisch;Position\n0;1;Test;1;1\n-1;1;Test2;2;2\n"
    file = create_temp_csv(csv_content)

    result = CsvExhibitImport.call(@event, file)

    assert_equal 2, result[:ignore_count], "Should ignore rows with ID <= 0"

    cleanup_temp_file(file)
  end

  test "re-imports its own ISO-8859-15 export" do
    event = events(:three)
    exhibit = exhibits(:one)
    exhibit.update_columns(is_approved: true)
    export = event.exhibits_as_csv
    row = CSV.parse(export, headers: true, col_sep: ';').find { |r| r['ID'] == exhibit.id.to_s }
    assert row, "the exhibit is part of the export"
    edited = export.sub(/^#{exhibit.id};true;/, "#{exhibit.id};false;")
    edited = edited.sub(/;#{row['Tisch']};#{row['Position']};/, ";9;3;")

    file = Tempfile.new(['export', '.csv'])
    file.binmode
    file.write(edited.encode(Encoding::ISO_8859_15))
    file.rewind
    result = CsvExhibitImport.call(event, file)

    exhibit.reload
    assert_equal 0, result[:failure_count], result[:errors].inspect
    assert_not exhibit.is_approved, "the umlaut header Bestätigt is recognised"
    assert_equal [9, 3], [exhibit.platform, exhibit.position]
  ensure
    file&.close!
  end

  test "an invalid row counts as failure instead of aborting the import" do
    exhibit = exhibits(:one)
    exhibit.update_column(:url, "not a url") # fails validation on save
    file = create_temp_csv("ID;MOC\n#{exhibit.id};Renamed\n")

    result = CsvExhibitImport.call(events(:three), file)

    assert_equal 1, result[:failure_count]
    assert_equal [exhibit.id.to_s], result[:errors]
    assert_equal "My first extraordinary MOC", exhibit.reload.name
    cleanup_temp_file(file)
  end

  private

  def create_temp_csv(content)
    file = Tempfile.new(['test', '.csv'])
    file.write(content)
    file.rewind
    file
  end

  def cleanup_temp_file(file)
    file.close
    file.unlink
  end
end
