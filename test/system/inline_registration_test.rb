require "application_system_test_case"

# Attendees, MOCs and accommodation requests are added, edited and deleted
# inside their section of the attendance page (Turbo Frames), see
# doc/plans/registration-flow-phase-2.md.
class InlineRegistrationTest < ApplicationSystemTestCase
  setup do
    AttendeeType.update_all(is_visible: true)
    @attendance = attendances(:three)
    @attendance.event.update!(has_accommodation: true)
  end

  def login_admin
    visit '/users/sign_in'
    fill_in 'user_email', :with => users(:thoherr).email
    fill_in 'user_password', :with => "test123"
    click_on 'submit'
    assert_selector "#logoutLink"
  end

  test "add an attendee inline" do
    login_admin
    visit attendance_path(@attendance, locale: :en)
    assert_selector "#attendance_status", text: "Attendees confirmed: 2 of 2"

    within("turbo-frame#attendees") { click_on "Register another attendee" }
    within("turbo-frame#attendees") do
      assert_selector "h2", text: "Add another attendee"
      select attendee_types(:one).name, from: 'attendee_attendee_type_id'
      fill_in 'attendee_given_name', with: "Inline"
      fill_in 'attendee_family_name', with: "Person"
      click_on 'submit'
    end

    within("turbo-frame#attendees") do
      assert_selector "td", text: "Inline Person"
      assert_no_selector "form"
    end
    assert_selector "#attendance_status", text: "Attendees confirmed: 2 of 3"
    assert_selector ".FlashNotice", text: "attendee has been added"
    assert_current_path attendance_path(@attendance), ignore_query: true
    take_screenshot
  end

  test "a missing field is reported inside the attendee section" do
    login_admin
    visit attendance_path(@attendance, locale: :en)

    within("turbo-frame#attendees") do
      click_on "Register another attendee"
      fill_in 'attendee_given_name', with: "Typeless"
      click_on 'submit'
      assert_selector ".FormErrors li", text: "Register as must be filled in"
      assert_equal "Typeless", find_field('attendee_given_name').value
    end
    # scrolled into view after the frame has rendered; wait for it like any other expectation
    page.document.synchronize do
      in_view = page.evaluate_script(<<~JS)
        (() => { const r = document.querySelector(".FormErrors").getBoundingClientRect();
                 return r.top >= 0 && r.bottom <= window.innerHeight; })()
      JS
      raise Capybara::ExpectationNotMet, "the error box is not scrolled into view" unless in_view
    end
    take_screenshot
  end

  test "an invalid MOC is shown again with the error in its section, then saved" do
    login_admin
    exhibit = Exhibit.create!(attendance: @attendance, name: "Inline MOC", unit: units(:one))
    visit attendance_path(@attendance, locale: :en)

    within("turbo-frame#exhibits") do
      find("tr", text: "Inline MOC").click_on "Edit"
      fill_in 'exhibit_url', with: "ftp://example.com/moc"
      click_on 'submit'
      assert_selector ".field_with_errors #exhibit_url"

      fill_in 'exhibit_url', with: "https://example.com/moc"
      click_on 'submit'
      assert_selector "td", text: "https://example.com/moc"
    end
    assert_selector ".FlashNotice", text: "MOC-data has been changed"
    assert_equal "https://example.com/moc", exhibit.reload.url
    assert_current_path attendance_path(@attendance), ignore_query: true
  end

  test "cancel closes the form without saving" do
    login_admin
    visit attendance_path(@attendance, locale: :en)

    within("turbo-frame#exhibits") do
      click_on "Register another MOC"
      fill_in 'exhibit_name', with: "Never saved"
      take_screenshot
      click_on "Cancel"
      assert_no_selector "form"
      assert_selector "table.ExhibitsTable"
    end
    assert_not Exhibit.exists?(name: "Never saved")
  end

  test "add, change and delete an accommodation request inline" do
    login_admin
    visit attendance_path(@attendance, locale: :en)

    within("turbo-frame#accommodations") do
      click_on "Add another accommodation request"
      select accommodation_types(:two).name, from: 'accommodation_accommodation_type_id'
      fill_in 'accommodation_count', with: 2
      click_on 'submit'
      assert_selector "td", text: accommodation_types(:two).name
    end
    assert_selector ".FlashNotice", text: "accommodation request has been added"
    accommodation = @attendance.accommodations.last
    assert_equal 2, accommodation.count

    within("turbo-frame#accommodations") do
      click_on "Edit"
      assert_selector "h2", text: "Change accommodation request for"
      fill_in 'accommodation_count', with: 1
      click_on 'submit'
      assert_no_selector "form"
    end
    assert_equal 1, accommodation.reload.count

    within("turbo-frame#accommodations") do
      accept_confirm { click_on "Delete" }
      assert_no_selector "td", text: accommodation_types(:two).name
    end
    assert_selector ".FlashNotice", text: "accommodation request has been deleted"
    assert_not Accommodation.exists?(accommodation.id)
  end

  test "the ticket QR code still opens after the attendee section was updated inline" do
    login_admin
    visit attendance_path(@attendance, locale: :en)

    within("turbo-frame#attendees") do
      find("tr", text: "Nick3").click_on "Edit"
      fill_in 'attendee_remarks', with: "Changed inline"
      click_on 'submit'
      assert_selector "td", text: "Changed inline"
      find("a.TicketQrLink[data-dialog='ticket-qr-103']").click
    end
    assert_selector "dialog#ticket-qr-103[open] img.TicketQrImage[src*='/attendees/103/ticket_qr.svg']"
    find("dialog#ticket-qr-103 button.TicketQrClose").click
    assert_no_selector "dialog#ticket-qr-103[open]"
  end

  test "editing an attendee from the event page is still a full page and returns there" do
    login_admin
    visit event_path(@attendance.event, locale: :en)

    attendees_list = find("details.CollapsibleTable", text: I18n.t("table_attendees", locale: :en))
    attendees_list.find("summary").click
    attendees_list.find("tr", text: "Nick3").click_on "Edit"

    assert_selector "h1", text: "Edit attendee data for"
    assert_no_link "Cancel"
    fill_in 'attendee_nickname', with: "Renamed3"
    click_on 'submit'

    assert_current_path event_path(@attendance.event), ignore_query: true
    assert_equal "Renamed3", attendees(:three).reload.nickname
  end
end
