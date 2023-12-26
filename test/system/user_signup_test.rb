require "application_system_test_case"

class UserSignupTest < ApplicationSystemTestCase
  test "sign up" do
    visit '/'
    assert has_content?('BrickEvent'), "BrickEvent"
    find_by_id('germanLink').click
    assert has_content?('Veranstaltungsübersicht'), "Veranstaltungsübersicht"
    assert has_content?('Melde Dich gleich an!'), "Melde Dich gleich an!"

    click_on 'login'
    assert has_content?('Anmeldung'), "Anmeldung"

    click_on 'sign_up'
    assert has_content?('Benutzeranmeldung'), "Benutzeranmeldung"

    mail = "myname@mymail.com"
    password = "MySecret"
    name = "Bugs Bunny"
    fill_in 'user_email', :with => mail
    fill_in 'user_password', :with => password
    fill_in 'user_password_confirmation', :with => password
    fill_in 'user_name', :with => name
    check 'user_accept_data_storage'
    click_on 'submit'

    # because we are not confirmed, we should not be logged in
    assert has_content?('BrickEvent'), "BrickEvent"
    assert has_content?('Veranstaltungsübersicht'), "Veranstaltungsübersicht"
    assert has_content?('Melde Dich gleich an!'), "Melde Dich gleich an!"
    assert has_content?('Ausloggen') == false, "Ausloggen"
    take_screenshot
  end

  test "sign up without accepting data storage" do
    visit '/'
    assert has_content?('BrickEvent'), "BrickEvent"
    find_by_id('germanLink').click
    assert has_content?('Veranstaltungsübersicht'), "Veranstaltungsübersicht"
    assert has_content?('Melde Dich gleich an!'), "Melde Dich gleich an!"

    click_on 'login'
    assert has_content?('Anmeldung'), "Anmeldung"

    click_on 'sign_up'
    assert has_content?('Benutzeranmeldung'), "Benutzeranmeldung"

    mail = "myname@mymail.com"
    password = "MySecret"
    name = "Bugs Bunny"
    fill_in 'user_email', :with => mail
    fill_in 'user_password', :with => password
    fill_in 'user_password_confirmation', :with => password
    fill_in 'user_name', :with => name
    click_on 'submit'

    # because we didn't accept data storage we are still on the form
    assert has_content?('BrickEvent'), "BrickEvent"
    assert has_content?('Benutzeranmeldung'), "Benutzeranmeldung"
    assert has_content?('Accept data storage Du musst der Speicherung Deiner Daten zustimmen!'), "Accept data storage Du musst der Speicherung Deiner Daten zustimmen!"

    fill_in 'user_password', :with => password
    fill_in 'user_password_confirmation', :with => password
    check 'user_accept_data_storage'
    click_on 'submit'

    # because we are not confirmed, we should not be logged in
    assert has_content?('BrickEvent'), "BrickEvent"
    assert has_content?('Veranstaltungsübersicht'), "Veranstaltungsübersicht"
    assert has_content?('Melde Dich gleich an!'), "Melde Dich gleich an!"
    assert has_content?('Ausloggen') == false, "Ausloggen"
    take_screenshot
  end

  test "sign in" do
    # needed by User.create! and normally done by before_action in app controller
    ActionMailer::Base.default_url_options[:host] = "localhost:3000"
    @user = User.create!(:email => "email@email.com",
                :password => "password",
                :password_confirmation => "password",
                :name => "My Name",
                :confirmed_at => Date.new(2020, 1, 1),
                :accept_data_storage => true)
    @user.confirm
    visit '/users/sign_in'
    fill_in 'user_email', :with => "email@email.com"
    fill_in 'user_password', :with => "password"
    click_on 'submit'

    find_by_id('germanLink').click
    assert has_content?('Meine Anmeldungen'), "Meine Anmeldungen"
    assert has_content?('Ausloggen'), "Ausloggen"
    take_screenshot
  end

end
