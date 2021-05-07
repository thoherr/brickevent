require 'test_helper'

class AttendeeTest < ActiveSupport::TestCase
  test "number of shirts ok" do
    has_shirt_count = attendees(:two)
    assert has_shirt_count.valid?
    assert has_shirt_count.errors.empty?
    expected_messages = {}
    assert_equal expected_messages, has_shirt_count.errors.messages
    missing_shirt_count = attendees(:four)
    assert_not missing_shirt_count.valid?
    assert_not missing_shirt_count.errors.empty?
    expected_messages = {:"T-Shirts"=>["Die Anzahl muss größer 0 sein, wenn eine Größe ausgewählt wurde"]}
    assert_equal expected_messages, missing_shirt_count.errors.messages
  end
end
