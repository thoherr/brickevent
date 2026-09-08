require "application_system_test_case"

class CollapsibleTablesTest < ApplicationSystemTestCase
  test "table toggle switches between show and hide" do
    visit '/users/sign_in'
    fill_in 'user_email', :with => users(:thoherr).email
    fill_in 'user_password', :with => "test123"
    click_on 'submit'
    visit event_path(events(:three))

    details = first("details.CollapsibleTable")
    assert_not details[:open]
    assert details.has_css?("span.WhenClosed", visible: true)
    assert details.has_css?("span.WhenOpen", visible: false)
    assert details.has_css?("table", visible: false)

    details.find("summary").click
    assert details[:open]
    assert details.has_css?("span.WhenOpen", visible: true)
    assert details.has_css?("span.WhenClosed", visible: false)
    assert details.has_css?("table", visible: true)
    take_screenshot

    details.find("summary").click
    assert details.has_css?("span.WhenClosed", visible: true)
    assert details.has_css?("table", visible: false)
  end
end
