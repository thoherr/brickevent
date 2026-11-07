require "test_helper"

# Saves and deletes from a section of the attendance page (Turbo Frame request)
# are answered with a Turbo Stream; all other requests keep their redirect.
# See doc/plans/registration-flow-phase-2.md.
class AttendanceSectionsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  TURBO_STREAM = "text/vnd.turbo-stream.html"

  setup do
    admin = users(:thoherr)
    admin.confirm
    sign_in admin
    @attendance = attendances(:three)
  end

  def frame_headers(section)
    { "Turbo-Frame" => section, "Accept" => "#{TURBO_STREAM}, text/html" }
  end

  def assert_section_stream(section, notice)
    assert_response :success
    assert_equal TURBO_STREAM, response.media_type
    assert_select "turbo-stream[action=replace][target=#{section}] template turbo-frame##{section}"
    assert_select "turbo-stream[action=replace][target=attendance_status]"
    assert_select "turbo-stream[action=replace][target=flashes] template .FlashNotice", text: notice
  end

  test "creating an attendee from its section answers with a stream" do
    assert_difference("@attendance.attendees.count") do
      post attendees_path(locale: :en), headers: frame_headers("attendees"), params: {
        attendee: { attendance_id: @attendance.id, attendee_type_id: attendee_types(:one).id,
                    given_name: "Stream", family_name: "Person" }
      }
    end
    assert_section_stream "attendees", "New attendee has been added."
    assert_select "turbo-stream[target=attendees] template td", text: "Stream Person"
  end

  test "creating an attendee without a frame still redirects" do
    post attendees_path(locale: :en), params: {
      attendee: { attendance_id: @attendance.id, attendee_type_id: attendee_types(:one).id, given_name: "Plain" }
    }
    assert_redirected_to attendance_path(@attendance, locale: :en)
  end

  test "a frame of another section does not get the stream" do
    post attendees_path(locale: :en), headers: frame_headers("exhibits"), params: {
      attendee: { attendance_id: @attendance.id, attendee_type_id: attendee_types(:one).id, given_name: "Other" }
    }
    assert_response :redirect
  end

  test "a failed update in the section re-renders the form inside the frame" do
    attendee = attendees(:three)
    patch attendee_path(attendee, locale: :en), headers: frame_headers("attendees"),
          params: { attendee: { attendee_type_id: "" } }

    assert_response :unprocessable_entity
    assert_select "turbo-frame#attendees form#edit_attendee_#{attendee.id}"
    assert_select "turbo-frame#attendees a", text: "Cancel"
  end

  test "the edit form loaded into the section has a heading and a cancel link" do
    get edit_attendee_path(attendees(:three), locale: :en), headers: { "Turbo-Frame" => "attendees" }
    assert_response :success
    assert_select "turbo-frame#attendees h2"
    assert_select "turbo-frame#attendees a[href^=?]", attendance_path(@attendance), text: "Cancel"
  end

  test "the edit form as a full page has no frame" do
    get edit_attendee_path(attendees(:three), locale: :en)
    assert_response :success
    assert_select "h1", text: /Edit attendee data/
    assert_select "turbo-frame#attendees", count: 0
  end

  test "deleting a MOC from its section answers with a stream" do
    exhibit = Exhibit.create!(attendance: @attendance, name: "Doomed MOC", unit: units(:one))
    delete exhibit_path(exhibit, locale: :en), headers: frame_headers("exhibits")

    assert_section_stream "exhibits", "MOC has been deleted."
    assert_not Exhibit.exists?(exhibit.id)
    assert_select "turbo-stream[target=exhibits] template td", text: "Doomed MOC", count: 0
  end

  test "updating an accommodation request from its section answers with a stream" do
    accommodation = Accommodation.create!(attendance: @attendance, accommodation_type: accommodation_types(:one), count: 1)
    patch accommodation_path(accommodation, locale: :de), headers: frame_headers("accommodations"),
          params: { accommodation: { count: 3 } }

    assert_section_stream "accommodations", "Der Hotelwunsch wurde geändert."
    assert_equal 3, accommodation.reload.count
  end

  test "the status line counts confirmed attendees and MOCs and flags MOCs without size" do
    Exhibit.create!(attendance: @attendance, name: "No size", unit: units(:one), is_approved: true)
    get attendance_path(@attendance, locale: :en)

    assert_select "#attendance_status li", text: /Registration confirmed: no/
    assert_select "#attendance_status li", text: "Attendees confirmed: 2 of 2"
    assert_select "#attendance_status li", text: /MOCs confirmed: 1 of 1\s+\(1 without size\)/
  end
end
