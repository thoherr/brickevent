require 'test_helper'

class AttendeesControllerTest < ActionController::TestCase
  setup do
    user = users(:two)
    user.confirm
    sign_in user
    @attendee = attendees(:two)
  end

  test "should get new" do
    get :new, params: { attendance_id: @attendee.attendance_id }
    assert_response :success
  end

  test "should create attendee" do
    assert_difference('Attendee.count') do
      post :create, params: { attendee: @attendee.attributes.except('id') }
    end

    assert_redirected_to attendance_path(assigns(:attendee).attendance)
  end

  test "should get edit" do
    get :edit, params: { id: @attendee.to_param }
    assert_response :success
  end

  test "should not get edit if unauthorized" do
    user = users(:one)
    user.confirm
    sign_in user
    assert_raise do
      get :edit, params: { id: @attendee.to_param }
    end
  end

  test "should update attendee" do
    put :update, params: { id: @attendee.to_param, attendee: @attendee.attributes }
    assert_redirected_to attendance_path(assigns(:attendee).attendance)
  end

  test "should not update attendee if unauthorized" do
    user = users(:one)
    user.confirm
    sign_in user
    assert_raise do
      put :update, params: { id: @attendee.to_param, attendee: @attendee.attributes }
    end
  end

  test "admin should be able to update attendee" do
    user = users(:thoherr)
    user.confirm
    sign_in user
    put :update, params: { id: @attendee.to_param, attendee: @attendee.attributes }
    assert_redirected_to attendance_path(assigns(:attendee).attendance)
  end

  test "should destroy attendee" do
    assert_difference('Attendee.count', -1) do
      delete :destroy, params: { id: @attendee.to_param }
    end

    assert_redirected_to attendance_path(assigns(:attendee).attendance)
  end
end
