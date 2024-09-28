require 'test_helper'

class VotesControllerTest < ActionController::TestCase
  setup do
    @exhibit = exhibits(:one)
  end

  test "should get new" do
    get :new, params: { id: @exhibit.id }
    assert_response :success
  end

  test "should create vote" do
    post :create, params: { id: @exhibit.id }
    assert_redirected_to new_vote_path(assigns(:exhibit))
  end

end
