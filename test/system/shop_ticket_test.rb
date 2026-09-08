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

    find("a.TicketQrLink[data-dialog='ticket-qr-103']").click
    assert_selector "dialog#ticket-qr-103[open] svg", visible: true
    assert_selector "dialog#ticket-qr-103[open]", text: "s3cr3tt1ck3t"
    take_screenshot

    find("dialog#ticket-qr-103 button.TicketQrClose").click
    assert_no_selector "dialog#ticket-qr-103[open]"
  end
end
