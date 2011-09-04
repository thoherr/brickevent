require 'test_helper'

class AttendeeTypesControllerTest < ActionController::TestCase
  setup do
    sign_in User.first
    @attendee_type = attendee_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:attendee_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create attendee_type" do
    assert_difference('AttendeeType.count') do
      post :create, :attendee_type => @attendee_type.attributes
    end

    assert_redirected_to attendee_type_path(assigns(:attendee_type))
  end

  test "should show attendee_type" do
    get :show, :id => @attendee_type.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @attendee_type.to_param
    assert_response :success
  end

  test "should update attendee_type" do
    put :update, :id => @attendee_type.to_param, :attendee_type => @attendee_type.attributes
    assert_redirected_to attendee_type_path(assigns(:attendee_type))
  end

  test "should destroy attendee_type" do
    assert_difference('AttendeeType.count', -1) do
      delete :destroy, :id => @attendee_type.to_param
    end

    assert_redirected_to attendee_types_path
  end
end
