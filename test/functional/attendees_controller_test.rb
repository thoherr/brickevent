require 'test_helper'

class AttendeesControllerTest < ActionController::TestCase
  setup do
    @attendee = attendees(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:attendees)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create attendee" do
    assert_difference('Attendee.count') do
      post :create, :attendee => @attendee.attributes
    end

    assert_redirected_to attendee_path(assigns(:attendee))
  end

  test "should show attendee" do
    get :show, :id => @attendee.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @attendee.to_param
    assert_response :success
  end

  test "should update attendee" do
    put :update, :id => @attendee.to_param, :attendee => @attendee.attributes
    assert_redirected_to attendee_path(assigns(:attendee))
  end

  test "should destroy attendee" do
    assert_difference('Attendee.count', -1) do
      delete :destroy, :id => @attendee.to_param
    end

    assert_redirected_to attendees_path
  end
end
