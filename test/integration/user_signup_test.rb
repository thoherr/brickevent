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
    @user.confirm!
    visit '/users/sign_in'
    fill_in 'user_email', :with => @user.email
    fill_in 'user_password', :with => "password"
    click_on 'submit'

  end

  test "sign up" do

    visit '/'
    assert page.has_content?('BrickEvent'), "BrickEvent"
    assert page.has_content?('Veranstaltungsübersicht'), "Veranstaltungsübersicht"
    assert page.has_content?('Melde Dich gleich an!'), "Melde Dich gleich an!"

    click_on 'login'
    assert page.has_content?('Anmeldung'), "Anmeldung"

    click_on 'sign_up'
    assert page.has_content?('Benutzeranmeldung'), "Benutzeranmeldung"

    m = "myname@mymail.com"
    pw = "MySecret"
    n = "Bugs Bunny"
    fill_in 'user_email', :with => m
    fill_in 'user_password', :with => pw
    fill_in 'user_password_confirmation', :with => pw
    fill_in 'user_name', :with => n
    check 'user_accept_data_storage'
    click_on 'submit'

    # because we are not confirmed, we should not be logged in
    assert page.has_content?('BrickEvent'), "BrickEvent"
    assert page.has_content?('Veranstaltungsübersicht'), "Veranstaltungsübersicht"
    assert page.has_content?('Melde Dich gleich an!'), "Melde Dich gleich an!"
    assert page.has_content?('Ausloggen') == false, "Ausloggen"

  end

  test "sign up without accepting data storage" do

    visit '/'
    assert page.has_content?('BrickEvent'), "BrickEvent"
    assert page.has_content?('Veranstaltungsübersicht'), "Veranstaltungsübersicht"
    assert page.has_content?('Melde Dich gleich an!'), "Melde Dich gleich an!"

    click_on 'login'
    assert page.has_content?('Anmeldung'), "Anmeldung"

    click_on 'sign_up'
    assert page.has_content?('Benutzeranmeldung'), "Benutzeranmeldung"

    m = "myname@mymail.com"
    pw = "MySecret"
    n = "Bugs Bunny"
    fill_in 'user_email', :with => m
    fill_in 'user_password', :with => pw
    fill_in 'user_password_confirmation', :with => pw
    fill_in 'user_name', :with => n
    click_on 'submit'

    # because we are not confirmed, we should not be logged in
    assert page.has_content?('BrickEvent'), "BrickEvent"
    assert page.has_content?('Benutzeranmeldung'), "Benutzeranmeldung"
    # TODO assert error message!

    fill_in 'user_password', :with => pw
    fill_in 'user_password_confirmation', :with => pw
    check 'user_accept_data_storage'
    click_on 'submit'

    # because we are not confirmed, we should not be logged in
    assert page.has_content?('BrickEvent'), "BrickEvent"
    assert page.has_content?('Veranstaltungsübersicht'), "Veranstaltungsübersicht"
    assert page.has_content?('Melde Dich gleich an!'), "Melde Dich gleich an!"
    assert page.has_content?('Ausloggen') == false, "Ausloggen"

  end

  test "sign in" do
    @user = User.create!(:email => "email@email.com",
                :password => "password",
                :password_confirmation => "password",
                :name => "My Name")
    @user.confirm!
    visit '/users/sign_in'
    fill_in 'user_email', :with => "email@email.com"
    fill_in 'user_password', :with => "password"
    click_on 'submit'

    assert page.has_content?('Meine Anmeldungen'), "Meine Anmeldungen"
    assert page.has_content?('Ausloggen'), "Ausloggen"

  end

  test "sign up for event" do

    login_dummy_user
    assert page.has_content?('Meine Anmeldungen'), "Meine Anmeldungen"
    assert page.has_content?('Ausloggen'), "Ausloggen"

    visit new_attendance_path(:event_id => events(:one).id, :user_id => @user.id)
    assert page.has_content?('Anmeldung für'), "Anmeldung für"
    assert page.has_content?('Vielen Dank, dass Du Dich zur Teilnahme an'), "Vielen Dank, dass Du Dich zur Teilnahme an"

    click_on 'submit'
    assert page.has_content?('Anmeldung für'), "Anmeldung für"
    # TODO: This should be true, but it isn't.....
    # CHECK
    #assert page.has_content?('Du hast bisher 1 Person angemeldet'), "Du hast bisher 1 Person angemeldet"

  end

end
