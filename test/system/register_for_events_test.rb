require "application_system_test_case"

class RegisterForEventsTest < ApplicationSystemTestCase
  # test "visiting the index" do
  #   visit register_for_events_url
  #
  #   assert_selector "h1", text: "RegisterForEvent"
  # end

  test "visting events overview" do
    visit '/'
    assert_text "BrickEvent"
    click_on 'German'
    assert_text "Veranstaltungsübersicht"
    click_on 'login'
    assert_text "Anmeldung"
  end
end
