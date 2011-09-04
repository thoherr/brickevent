require 'test_helper'

class AccommodationTypesControllerTest < ActionController::TestCase
  setup do
    sign_in User.first
    @accommodation_type = accommodation_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:accommodation_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create accommodation_type" do
    assert_difference('AccommodationType.count') do
      post :create, :accommodation_type => @accommodation_type.attributes
    end

    assert_redirected_to accommodation_type_path(assigns(:accommodation_type))
  end

  test "should show accommodation_type" do
    get :show, :id => @accommodation_type.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @accommodation_type.to_param
    assert_response :success
  end

  test "should update accommodation_type" do
    put :update, :id => @accommodation_type.to_param, :accommodation_type => @accommodation_type.attributes
    assert_redirected_to accommodation_type_path(assigns(:accommodation_type))
  end

  test "should destroy accommodation_type" do
    assert_difference('AccommodationType.count', -1) do
      delete :destroy, :id => @accommodation_type.to_param
    end

    assert_redirected_to accommodation_types_path
  end
end
