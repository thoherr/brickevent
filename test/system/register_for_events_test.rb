require "application_system_test_case"

class RegisterForEventsTest < ApplicationSystemTestCase
  def login_dummy_user
    @user = User.create!(:email => "dummy@email.com",
                         :password => "password",
                         :password_confirmation => "password",
                         :name => "Dummy User")
    @user.confirm
    visit '/users/sign_in'
    fill_in 'user_email', :with => @user.email
    fill_in 'user_password', :with => "password"
    click_on 'Anmelden'
  end

  test "visting events overview" do
    visit '/'
    assert_text "BrickEvent"
    click_on 'German'
    assert_text "Veranstaltungsübersicht"
    click_on 'Anmelden'
    assert_text "Anmeldung"
    take_screenshot
  end

  test "register for event" do

    travel_to Time.zone.local(2011, 7, 15)

    login_dummy_user
    click_on 'German'

    assert has_content?('Meine Anmeldungen'), "Meine Anmeldungen"
    assert has_content?('Ausloggen'), "Ausloggen"

    click_on "Zur Teilnahme an ' Number 3 ' anmelden"
    assert has_content?('Anmeldung für'), "Anmeldung für"
    assert has_content?('Vielen Dank, dass Du Dich zur Teilnahme an'), "Vielen Dank, dass Du Dich zur Teilnahme an"

    click_on 'Anmeldung an der Veranstaltung bestätigen'
    assert has_content?('Anmeldung für'), "Anmeldung für"
    assert has_content?('Du hast 1 Teilnehmer angemeldet'), "Du hast 1 Teilnehmer angemeldet"
    take_screenshot
  end
end
