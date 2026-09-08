require "test_helper"

# The Avo backend must only be reachable for admins (see config/initializers/avo.rb).
class AvoAccessTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "anonymous visitors are sent to the sign-in page" do
    get "/avo"
    assert_redirected_to "/users/sign_in"
  end

  test "signed-in non-admins are sent to the frontend" do
    user = users(:one)
    user.confirm
    sign_in user

    get "/avo"
    assert_redirected_to "/events"

    get "/avo/resources/users"
    assert_redirected_to "/events"
  end

  test "admins can open the backend" do
    admin = users(:thoherr)
    admin.confirm
    sign_in admin

    get "/avo"
    follow_redirect! while response.redirect?
    assert_response :success
    assert_match %r{/avo/}, request.path

    get "/avo/resources/attendees"
    assert_response :success
    assert_select "body", /Attendee/i
  end
end
