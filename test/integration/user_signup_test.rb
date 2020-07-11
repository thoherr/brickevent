# encoding: UTF-8
require 'test_helper'
require 'capybara/rails'

class UserSignupTest < ActionDispatch::IntegrationTest
  fixtures :all

  include Capybara::DSL

  def login_dummy_user
    @user = User.create!(:email => "dummy@email.com",
                :password => "password",
                :password_confirmation => "password",
                :name => "Dummy User")
    @user.confirm
    visit '/users/sign_in'
    fill_in 'user_email', :with => @user.email
    fill_in 'user_password', :with => "password"
    click_on 'submit'

  end

  test "sign up" do

    visit '/'
    assert has_content?('BrickEvent'), "BrickEvent"
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

  end

  test "sign up without accepting data storage" do

    visit '/'
    assert has_content?('BrickEvent'), "BrickEvent"
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

  end

  test "sign in" do
    # needed by User.create! and normally done by before_filter in app controller
    ActionMailer::Base.default_url_options[:host] = "localhost:3000"
    @user = User.create!(:email => "email@email.com",
                :password => "password",
                :password_confirmation => "password",
                :name => "My Name")
    @user.confirm
    visit '/users/sign_in'
    fill_in 'user_email', :with => "email@email.com"
    fill_in 'user_password', :with => "password"
    click_on 'submit'

    assert has_content?('Meine Anmeldungen'), "Meine Anmeldungen"
    assert has_content?('Ausloggen'), "Ausloggen"

  end

  test "sign up for event" do

    login_dummy_user
    assert has_content?('Meine Anmeldungen'), "Meine Anmeldungen"
    assert has_content?('Ausloggen'), "Ausloggen"

    visit new_attendance_path(:event_id => events(:one).id, :user_id => @user.id)
    assert has_content?('Anmeldung für'), "Anmeldung für"
    assert has_content?('Vielen Dank, dass Du Dich zur Teilnahme an'), "Vielen Dank, dass Du Dich zur Teilnahme an"

    click_on 'submit'
    assert has_content?('Anmeldung für'), "Anmeldung für"
    assert has_content?('Du hast 1 Teilnehmer angemeldet'), "Du hast 1 Teilnehmer angemeldet"

  end

end
