require "application_system_test_case"

class AdminEventTest < ApplicationSystemTestCase
  def login_admin_user
    # needed by User.create! and normally done by before_action in app controller
    ActionMailer::Base.default_url_options[:host] = "localhost:3000"
    @user = User.create!(:email => "admin@mytestdomain.de",
                         :password => "password",
                         :password_confirmation => "password",
                         :name => "Admin User",
                         :is_admin => true)
    @user.confirm
    visit '/users/sign_in'
    fill_in 'user_email', :with => @user.email
    fill_in 'user_password', :with => "password"
    click_on 'submit'
  end

  test "admin event" do

    travel_to Time.zone.local(2024, 11, 5)

    login_admin_user
    find_by_id('germanLink').click

    assert has_content?('Meine Anmeldungen'), "Meine Anmeldungen"
    assert has_content?('Ausloggen'), "Ausloggen"

    assert has_content?('Administration'), "Administration"

    click_on "Übersicht der Anmeldungen für 'Number 3'"
    assert has_content?('Alle Anmeldedaten für Number 3'), "Alle Anmeldedaten für Number 3"
    assert has_content?('Anmeldeliste'), "Anmeldeliste"
    assert has_content?('Teilnehmerliste'), "Teilnehmerliste"
    assert has_content?('MOC-Liste'), "MOC-Liste"

    take_screenshot
  end

  test "admin backend" do

    travel_to Time.zone.local(2024, 11, 5)

    login_admin_user
    find_by_id('germanLink').click

    assert has_content?('Meine Anmeldungen'), "Meine Anmeldungen"
    assert has_content?('Ausloggen'), "Ausloggen"

    assert has_content?('Administration'), "Administration"

    click_on "Administration"
    take_screenshot

    assert has_content?('LUGs'), "LUGs"
    assert has_content?('Events'), "Events"
    assert has_content?('MOCs'), "MOCs"
    assert has_content?('Third Event'), "Third Event"

    find('td', text: 'Third Event').sibling('td', class: 'actions').find('a', text: 'Bearbeiten').click
    # Wait for Active Scaffold AJAX to load the edit form
    # Using longer timeout as Active Scaffold uses jQuery AJAX which may be slower
    sleep 1  # Give Active Scaffold time to initiate the request
    assert has_content?('Editiere Third Event', wait: 10), "Editiere Third Event"
    take_screenshot
    find('a', text: 'Abbrechen').click

    find('td', text: 'Bricking Bavaria 2011').sibling('td', class: 'actions').find('a', text: 'Bearbeiten').click
    # Wait for Active Scaffold AJAX to load the edit form
    assert has_content?('Editiere Bricking Bavaria 2011', wait: 5), "Editiere Bricking Bavaria 2011"
    take_screenshot

    find('textarea', class: 'description-input').fill_in with: 'BB is the best'
    find('input', class: 'submit').click
    assert has_content?('BB is the best'), "BB is the best"
    take_screenshot

  end

end
