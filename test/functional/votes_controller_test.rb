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
    request.session[:session_id] = 42
    assert_difference 'Vote.count' do
      post :create, params: { id: @exhibit.id }
      assert_response :redirect
      assert_redirected_to new_vote_path(assigns(:exhibit))
    end
    request.session[:session_id] = 48
    assert_difference 'Vote.count' do
      post :create, params: { id: @exhibit.id }
      assert_response :redirect
      assert_redirected_to new_vote_path(assigns(:exhibit))
    end
  end

  test "cannot vote twice" do
    request.session[:session_id] = 42
    assert_difference 'Vote.count' do
      post :create, params: { id: @exhibit.id }
    end
    assert_difference 'Vote.count', 0 do
      post :create, params: { id: @exhibit.id }
      assert_redirected_to new_vote_path(assigns(:exhibit), :notice => I18n.t('cannot_vote_twice'))
    end

    request.session[:session_id] = 48
    assert_difference 'Vote.count' do
      post :create, params: { id: @exhibit.id }
    end
    assert_difference 'Vote.count', 0 do
      post :create, params: { id: @exhibit.id }
      assert_redirected_to new_vote_path(assigns(:exhibit), :notice => I18n.t('cannot_vote_twice'))
    end

    request.session[:session_id] = 42
    assert_difference 'Vote.count', 0 do
      post :create, params: { id: @exhibit.id }
      assert_redirected_to new_vote_path(assigns(:exhibit), :notice => I18n.t('cannot_vote_twice'))
    end

    request.session[:session_id] = 44
    assert_difference 'Vote.count' do
      post :create, params: { id: @exhibit.id }
      assert_response :redirect
      assert_redirected_to new_vote_path(assigns(:exhibit))
    end
  end

  test "wrong data should raise INVALID REQUEST message" do
    request.session[:session_id] = 42
    assert_raise "INVALID REQUEST" do
      post :create, params: { id: 12345 }
    end
  end
end
