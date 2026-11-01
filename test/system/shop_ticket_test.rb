require "application_system_test_case"

class ShopTicketTest < ApplicationSystemTestCase
  def login_admin
    visit '/users/sign_in'
    fill_in 'user_email', :with => users(:thoherr).email
    fill_in 'user_password', :with => "test123"
    click_on 'submit'
  end

  test "ticket qr dialog opens from the attendance view" do
    login_admin
    visit attendance_path(attendances(:three))
    assert_text "Shop"

    dialog = find("dialog#ticket-qr-103", visible: :all)
    assert_not dialog[:open], "dialog should be closed initially"

    img = find("dialog#ticket-qr-103 img.TicketQrImage", visible: :all)
    assert img[:src].blank?, "the QR code should only be fetched when the dialog opens"

    find("a.TicketQrLink[data-dialog='ticket-qr-103']").click
    assert_selector "dialog#ticket-qr-103[open] img.TicketQrImage[src*='/attendees/103/ticket_qr.svg']", visible: true
    # the image is fetched on open; wait for it like any other Capybara expectation
    loaded = page.document.synchronize do
      done = page.evaluate_script("(function (img) { return img.complete && img.naturalWidth > 0; })(document.querySelector('#ticket-qr-103 img.TicketQrImage'))")
      raise Capybara::ExpectationNotMet, "the QR code image has not loaded yet" unless done
      done
    end
    assert loaded, "the QR code image should have loaded"
    assert_selector "dialog#ticket-qr-103[open]", text: "s3cr3tt1ck3t"
    take_screenshot

    find("dialog#ticket-qr-103 button.TicketQrClose").click
    assert_no_selector "dialog#ticket-qr-103[open]"
  end
end
