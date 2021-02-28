require 'test_helper'

class ExhibitsControllerTest < ActionController::TestCase
  setup do
    user = User.first
    user.confirm
    sign_in user
    @exhibit = exhibits(:one)
    @exhibit.attendance = attendances(:one)
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

  test "should update exhibit" do
    put :update, params: { id: @exhibit.to_param, exhibit: @exhibit.attributes }
    assert_redirected_to attendance_path(assigns(:exhibit).attendance)
  end

  test "should destroy exhibit" do
    assert_difference('Exhibit.count', -1) do
      delete :destroy, params: { id: @exhibit.to_param }
    end

    assert_redirected_to attendance_path attendances(:one)
  end
end
