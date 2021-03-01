require 'test_helper'

class AttendeesControllerTest < ActionController::TestCase
  setup do
    user = User.first
    user.confirm
    sign_in user
    @attendee = attendees(:one)
    @attendee.attendance = attendances(:one)
    @attendee.attendee_type = attendee_types(:one)
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

  test "should update attendee" do
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
