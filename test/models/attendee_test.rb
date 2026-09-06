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
  test "full name and to_s" do
    attendee = attendees(:one)
    assert_equal "Attendee One", attendee.full_name
    assert_equal "Attendee One (Aussteller)", attendee.to_s
  end

  test "attendee name parts are optional" do
    attendee = Attendee.new(attendance: attendances(:one), attendee_type: attendee_types(:one), given_name: "Marius")
    assert attendee.valid?, attendee.errors.full_messages.join(", ")
    assert_equal "Marius", attendee.full_name
  end
end
