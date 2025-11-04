require 'test_helper'

class ExhibitsControllerTest < ActionController::TestCase
  setup do
    user = users(:one)
    user.confirm
    sign_in user
    @exhibit = exhibits(:one)
    @exhibit.unit = units(:studs)
  end

  test "should get new" do
    get :new, params: { attendance_id: @exhibit.attendance_id }
    assert_response :success
  end

  test "should create exhibit" do
    assert_difference('Exhibit.count') do
      post :create, params: { exhibit: @exhibit.attributes.except('id') }
    end

    assert_redirected_to attendance_path(assigns(:exhibit).attendance)
  end

  test "should get edit" do
    get :edit, params: { id: @exhibit.to_param }
    assert_response :success
  end

  test "should not get edit if not owner" do
    user = users(:three)
    user.confirm
    sign_in user
    assert_raise do
      get :edit, params: { id: @exhibit.to_param }
    end
  end

  test "should get edit if admin" do
    user = users(:thoherr)
    user.confirm
    sign_in user
    get :edit, params: { id: @exhibit.to_param }
    assert_response :success
  end

  test "should update exhibit" do
    put :update, params: { id: @exhibit.to_param, exhibit: @exhibit.attributes }
    assert_redirected_to attendance_path(assigns(:exhibit).attendance)
  end

  test "should not update exhibit if unauthorized" do
    user = users(:three)
    user.confirm
    sign_in user
    assert_raise do
      put :update, params: { id: @exhibit.to_param, exhibit: @exhibit.attributes }
    end
  end

  test "should update exhibit if event manager" do
    user = users(:two)
    user.confirm
    sign_in user
    put :update, params: { id: @exhibit.to_param, exhibit: @exhibit.attributes }
    assert_redirected_to attendance_path(assigns(:exhibit).attendance)
  end

  test "should destroy exhibit" do
    assert_difference('Exhibit.count', -1) do
      delete :destroy, params: { id: @exhibit.to_param }
    end

    assert_redirected_to attendance_path attendances(:one)
  end

  test "should not destroy exhibit if unauthorized" do
    user = users(:three)
    user.confirm
    sign_in user
    assert_raise do
      delete :destroy, params: { id: @exhibit.to_param }
    end
  end

  test "should not be approvable by user" do
    assert_raise do
      post :approve, params: { id: @exhibit.id }
    end
  end

  test "should be approvable by event manager" do
    @user = users(:thoherr)
    @user.confirm
    sign_in @user
    post :approve, params: { id: @exhibit.id }
    assert_redirected_to event_path(@exhibit.attendance.event)
  end

  test "should be approvable by admin" do
    @user = users(:two)
    @user.confirm
    sign_in @user
    post :approve, params: { id: @exhibit.id }
    assert_redirected_to event_path(@exhibit.attendance.event)
  end

  test "should handle failed exhibit creation with invalid data" do
    assert_no_difference('Exhibit.count') do
      post :create, params: {
        exhibit: {
          attendance_id: @exhibit.attendance_id,
          unit_id: @exhibit.unit_id,
          url: "invalid-url"  # Invalid URL format
        }
      }
    end
    assert_response :success
    assert_template :new
  end

  test "should return json error on failed create" do
    post :create, params: {
      exhibit: {
        attendance_id: @exhibit.attendance_id,
        unit_id: @exhibit.unit_id,
        url: "invalid-url"
      },
      format: :json
    }
    assert_response :unprocessable_entity
    assert_equal 'application/json', response.media_type
  end

  test "should handle failed exhibit update with invalid data" do
    put :update, params: {
      id: @exhibit.to_param,
      exhibit: { url: "invalid-url" }
    }
    assert_response :success
    assert_template :edit
  end

  test "should return json error on failed update" do
    put :update, params: {
      id: @exhibit.to_param,
      exhibit: { url: "invalid-url" },
      format: :json
    }
    assert_response :unprocessable_entity
    assert_equal 'application/json', response.media_type
  end

end
