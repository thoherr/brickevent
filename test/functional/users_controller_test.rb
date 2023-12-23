require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    @user.confirm
    sign_in @user
  end

  test "user should get edit for itself" do
    get :edit, params: { id: @user.to_param }
    assert_response :success
  end

  test "user should get edit when admin" do
    @user = users(:thoherr)
    @user.confirm
    sign_in @user

    get :edit, params: { id: users(:two).to_param }
    assert_response :success
  end

  test "should get unauthorized access when editing another user" do
    assert_raise do
      get :edit, params: { id: users(:two).to_param }
    end
  end

  test "should update own data" do
    put :update, params: { id: @user.to_param, user: @user.attributes }
    assert_redirected_to events_path
  end

  test "should get unauthorized access when updating another user" do
    assert_raise do
      put :update, params: { id: users(:two).to_param, user: users(:two).attributes }
    end
  end

  test "should update data of another user when admin" do
    @user = users(:thoherr)
    @user.confirm
    sign_in @user

    put :update, params: { id: users(:one).to_param, user: users(:one).attributes }
    assert_redirected_to events_path
  end

end
