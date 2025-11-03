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
