require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  fixtures :all

  # test "the truth" do
  #   assert true
  # end
  
  test "sign up" do
    get "/"
    assert_response :success
    
    get "/users/sign_in"
    assert_response :success

    get "/users/sign_up"
    assert_response :success

    u = users(:thoherr)
    pw = "MySecret"

    post_via_redirect user_registration_path, :email => u.email, :password => pw, :password_confirmation => pw,
              :name => u.name, :lug => u.lug, :nickname => u.nickname, :address => u.address, :phone => u.phone
    assert_response :success
    puts path
  
    #assert_equal 'Welcome! You have signed up successfully.', flash[:notice]
  end

end
