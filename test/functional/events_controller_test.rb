# encoding: UTF-8

require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  setup do
    user = User.first
    user.confirm!
    sign_in user
    @event = events(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:events)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create event" do
    assert_difference('Event.count') do
      post :create, :event => @event.attributes
    end

    assert_redirected_to event_path(assigns(:event))
  end

  test "should show event" do
    get :show, :id => @event.to_param
    assert_response :success
  end

  test "should get attendees as csv for event" do
    get :attendees_as_csv, :id => events(:three).to_param
    assert_response :success
    assert_equal "Typ;Name;LUG;Nickname;EMail;AFOLs-Abend;Bemerkungen;T-Shirt-Größe\nHelfer;Attendee3;LUG2;Nick3;;true;None;\nAussteller;Attendee2;LUG1;Nick2;;false;Hi, there;\nAussteller;Attendee1;LUG1;Nick1;;true;Glad to see you;\n", response.body
  end

  test "should get exhibits as csv for event" do
    get :exhibits_as_csv, :id => events(:three).to_param
    assert_response :success
    assert_equal "Name;MOC;Beschreibung;URL;Größe in Studs;Größe;Größe x;Größe y;Größe z;Größe Einheit;Größe x (m);Größe y (m);Größe z (m);Versicherungswert;Baustunden;Anzahl Steine;Strom?;Sammeltransport;Gemeinschaftsprojekt?;Teil Gemeinschaftsprojekt;Name Gemainschaftsprojekt\nMyString;Another great MOC;Even more awesome;MyString;2400 * 6400;Huge;2400;6400;;studs;;;;10;10.0;1;false;true;false;false;-\nMyString;My first extraordinary MOC;Very awesome;MyString;160 by 240;MyString;160;240;;studs;;;;1000;1;1;false;false;false;false;-\n", response.body
  end

  test "should get edit" do
    get :edit, :id => @event.to_param
    assert_response :success
  end

  test "should update event" do
    put :update, :id => @event.to_param, :event => @event.attributes
    assert_redirected_to event_path(assigns(:event))
  end

  test "should destroy event" do
    assert_difference('Event.count', -1) do
      delete :destroy, :id => @event.to_param
    end

    assert_redirected_to events_path
  end
end
