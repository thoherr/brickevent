require 'test_helper'

class AttendancesControllerTest < ActionController::TestCase
  setup do
    user = users(:one)
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

  test "should be approvable by admin" do
    @user = users(:thoherr)
    @user.confirm
    sign_in @user
    post :approve, params: { id: @attendance.id }
    assert_redirected_to event_path(@attendance.event)
  end

  test "should be approvable by event manager" do
    @user = users(:two)
    @user.confirm
    sign_in @user
    post :approve, params: { id: @attendance.id }
    assert_redirected_to event_path(@attendance.event)
  end

  test "should not be approvable by user" do
    assert_raise do
      post :approve, params: { id: @attendance.id }
    end
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

  test "should not show attendance if unauthorized" do
    assert_raise do
      get :show, params: { id: attendances(:two).to_param }
    end
  end
end
