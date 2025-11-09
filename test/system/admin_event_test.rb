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
    sleep 1 # Wait for Avo to load
    take_screenshot

    # Verify Avo admin interface loaded
    assert has_content?('BrickEvent Admin'), "Avo app name"

    # Verify key resources are accessible in Avo
    # Avo displays resources in the sidebar navigation
    assert has_content?('Events'), "Events resource"
    assert has_content?('Lugs'), "Lugs resource"
    assert has_content?('Users'), "Users resource"
    assert has_content?('Attendees'), "Attendees resource"

    # Click on Events resource to verify it works
    click_on 'Events'
    sleep 1
    take_screenshot

    # Verify Events list loads in Avo
    assert has_content?('Third Event'), "Third Event in Avo"
    assert has_content?('Bricking Bavaria 2011'), "Bricking Bavaria 2011 in Avo"

    take_screenshot

  end

end
