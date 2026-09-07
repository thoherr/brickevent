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
  test "voucher code is generated after create" do
    attendee = Attendee.create!(attendance: attendances(:one), attendee_type: attendee_types(:one), given_name: "New")
    assert_match(/\A#{attendee.id}-[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}\z/, attendee.voucher_code)
    assert_equal attendee.voucher_code, attendee.reload.voucher_code
    assert_nil attendee.voucher_exported_at
  end

  test "order link uses the event shop url" do
    attendee = attendees(:one)
    assert_equal "https://pretix.example.com/lug1/ev3/redeem?voucher=#{attendee.voucher_code}", attendee.order_link
    assert_nil attendees(:four).order_link, "event without shop has no order link"
    attendee.voucher_code = nil
    assert_nil attendee.order_link
  end

  test "order link visibility" do
    attendee = attendees(:one)
    assert attendee.show_order_link?

    attendee.is_approved = false
    assert_not attendee.show_order_link?, "unapproved attendees get no order link"
    attendee.is_approved = true

    attendee.event.show_order_link = false
    assert_not attendee.show_order_link?, "event flag hides the order link"
    attendee.event.show_order_link = true

    attendee.order_code = "ABC"
    attendee.order_status = "pending"
    assert_not attendee.show_order_link?, "pending order blocks the link"
    attendee.order_status = "canceled"
    assert attendee.show_order_link?, "canceled order frees the link"
  end

  test "ticket visibility" do
    attendee = attendees(:three)
    assert attendee.show_ticket?
    assert attendee.has_order?
    assert_not attendee.show_order_link?

    attendee.order_status = "pending"
    assert_not attendee.show_ticket?
    assert attendee.order_pending?
  end
end
