require 'test_helper'

class AccommodationsControllerTest < ActionController::TestCase
  setup do
    user = User.first
    user.confirm!
    sign_in user
    @accommodation = accommodations(:one)
    @attendance = attendances(:one)
    @accommodation.attendance = @attendance
    @accommodation.accommodation_type = accommodation_types(:one)
  end

  test "should get new" do
    get :new, :attendance_id => @accommodation.attendance_id
    assert_response :success
  end

  test "should create accommodation" do
    assert_difference('Accommodation.count') do
      post :create, :accommodation => @accommodation.attributes
    end

    assert_redirected_to attendance_path(assigns(:accommodation).attendance)
  end

  test "should get edit" do
    get :edit, :id => @accommodation.to_param
    assert_response :success
  end

  test "should update accommodation" do
    put :update, :id => @accommodation.to_param, :accommodation => @accommodation.attributes
    assert_redirected_to attendance_path(assigns(:accommodation).attendance)
  end

  test "should destroy accommodation" do
    assert_difference('Accommodation.count', -1) do
      delete :destroy, :id => @accommodation.to_param
    end

    assert_redirected_to attendance_path(1)
  end
end
