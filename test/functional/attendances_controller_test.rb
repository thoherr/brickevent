require 'test_helper'

class AttendancesControllerTest < ActionController::TestCase
  setup do
    user = User.first
    user.confirm
    sign_in user
    @attendance = attendances(:one)
  end

  test "should get index" do
    get :index, params: {}
    assert_response :success
    assert_not_nil assigns(:attendances)
  end

  test "should get new" do
    get :new, params: {}
    assert_response :success
  end

  test "should create attendance" do
    assert_difference('Attendance.count') do
      @attendance.event = events(:fourty_two)  # avoid to break uniqueness
      post :create, params: { attendance: @attendance.attributes }
    end

    assert_redirected_to attendance_path(assigns(:attendance))
  end

  test "should show attendance" do
    get :show, params: { id: @attendance.to_param }
    assert_response :success
  end
end
