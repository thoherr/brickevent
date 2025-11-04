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

  test "should approve attendance with JSON format" do
    @user = users(:thoherr)
    @user.confirm
    sign_in @user

    post :approve, params: { id: @attendance.id, format: :json }

    assert_response :ok
    assert_equal 'application/json', response.media_type
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

  test "should handle failed attendance creation with invalid data" do
    assert_no_difference('Attendance.count') do
      post :create, params: {
        attendance: {
          user_id: nil,  # Required field
          event_id: nil   # Required field
        }
      }
    end
    assert_response :success
    assert_template :new
  end

  test "should return json error on failed create" do
    post :create, params: {
      attendance: {
        user_id: nil,
        event_id: nil
      },
      format: :json
    }
    assert_response :unprocessable_entity
    assert_equal 'application/json', response.media_type
  end

  test "should copy exhibits from another attendance" do
    @user = users(:one)
    @user.confirm
    sign_in @user

    other_attendance = attendances(:two)

    post :copy_exhibits, params: {
      id: @attendance.id,
      other_attendance_id: other_attendance.id
    }

    assert_redirected_to attendances_url
    assert_equal 'Einträge wurden kopiert.', flash[:notice]
  end

  test "should add former exhibit to attendance" do
    @user = users(:one)
    @user.confirm
    sign_in @user

    former_exhibit = exhibits(:one)

    post :add_former_exhibit, params: {
      id: @attendance.id,
      former_exhibit_id: former_exhibit.id
    }

    assert_redirected_to attendances_url
    assert_equal 'Eintrag wurde kopiert.', flash[:notice]
  end

  test "should return json for former exhibits" do
    get :former_exhibits, params: { id: @attendance.id, format: :json }
    assert_response :success
    assert_equal 'application/json', response.media_type
  end
end
