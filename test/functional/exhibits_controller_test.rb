require 'test_helper'

class ExhibitsControllerTest < ActionController::TestCase
  setup do
    @exhibit = exhibits(:one)
    attendance = attendances(:one)
    @exhibit.attendance = attendance
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:exhibits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create exhibit" do
    assert_difference('Exhibit.count') do
      post :create, :exhibit => @exhibit.attributes
    end

    assert_redirected_to attendance_path(assigns(:exhibit).attendance)
  end

  test "should show exhibit" do
    get :show, :id => @exhibit.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @exhibit.to_param
    assert_response :success
  end

  test "should update exhibit" do
    put :update, :id => @exhibit.to_param, :exhibit => @exhibit.attributes
    assert_redirected_to attendance_path(assigns(:exhibit).attendance)
  end

  test "should destroy exhibit" do
    assert_difference('Exhibit.count', -1) do
      delete :destroy, :id => @exhibit.to_param
    end

    assert_redirected_to exhibits_path
  end
end
