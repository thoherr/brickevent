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

  test "should handle failed attendee creation with invalid data" do
    assert_no_difference('Attendee.count') do
      post :create, params: {
        attendee: {
          attendance_id: @attendee.attendance_id,
          attendee_type_id: @attendee.attendee_type_id,
          shirt_size: "L",  # Has shirt size but...
          number_of_shirts: nil  # ...no shirt count (violates validation)
        }
      }
    end
    assert_response :success
    assert_template :new
  end

  test "should return json error on failed create" do
    post :create, params: {
      attendee: {
        attendance_id: @attendee.attendance_id,
        attendee_type_id: @attendee.attendee_type_id,
        shirt_size: "L",
        number_of_shirts: nil
      },
      format: :json
    }
    assert_response :unprocessable_entity
    assert_equal 'application/json', response.media_type
  end

  test "should handle failed attendee update with invalid data" do
    put :update, params: {
      id: @attendee.to_param,
      attendee: {
        shirt_size: "L",
        number_of_shirts: nil
      }
    }
    assert_response :success
    assert_template :edit
  end

  test "should return json error on failed update" do
    put :update, params: {
      id: @attendee.to_param,
      attendee: {
        shirt_size: "L",
        number_of_shirts: nil
      },
      format: :json
    }
    assert_response :unprocessable_entity
    assert_equal 'application/json', response.media_type
  end

  test "should approve attendee when authorized" do
    user = users(:thoherr)  # admin
    user.confirm
    sign_in user
    attendee = attendees(:one)
    original_approval_status = attendee.is_approved
    post :approve, params: { id: attendee.id }
    assert_redirected_to event_path(attendee.attendance.event)
    assert_equal !original_approval_status, attendee.reload.is_approved
  end

  test "should deny approval when not authorized" do
    user = users(:one)  # not admin or event manager
    user.confirm
    sign_in user
    assert_raise do
      post :approve, params: { id: @attendee.id }
    end
  end
end
