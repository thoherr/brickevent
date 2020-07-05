require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:thoherr)
    @user.confirm
    sign_in @user
  end

  test "should get edit" do
    get :edit, :id => @user.to_param
    assert_response :success
  end

  test "should update user" do
    put :update, :id => @user.to_param, :user => @user.attributes
    assert_redirected_to events_path
  end
end
