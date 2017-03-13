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

  test "should show event" do
    get :show, :id => @event.to_param
    assert_response :success
  end

  test "should get attendees as csv for event" do
    get :attendees_as_csv, :id => events(:three).to_param
    assert_response :success
    assert_equal "Typ;Bestätigt;Name;LUG;Nickname;EMail;Telefon;Adresse;AFOLs-Abend;Ticket;Bemerkungen;T-Shirt-Größe\nHelfer;false;Attendee3;LUG2;Nick3;;+49 171 5715348;Jeschkenstr. 49, 82538 Geretsried;true;true;None;\nAussteller;false;Attendee2;LUG1;Nick2;;MyString;MyString;false;false;Hi, there;\nAussteller;false;Attendee1;LUG1;Nick1;;+49 171 5715348;Jeschkenstr. 49, 82538 Geretsried;true;true;Glad to see you;\n", response.body.encode(Encoding::UTF_8)
  end

  test "should get exhibits as csv for event" do
    get :exhibits_as_csv, :id => events(:three).to_param
    assert_response :success
    assert_equal "Bestätigt;Name;MOC;Beschreibung;URL;Größe in Studs;Größe;Größe x;Größe y;Größe z;Größe Einheit;Größe x (m);Größe y (m);Größe z (m);Versicherungswert;Baustunden;Anzahl Steine;Strom?;Sammeltransport;Gemeinschaftsprojekt?;Teil Gemeinschaftsprojekt;Name Gemeinschaftsprojekt\nfalse;MyString;Another great MOC;Even more awesome;MyString;2400 * 6400;Huge;24;64;;cm;24.0;64.0;;10;10.0;1;false;true;false;false;-\ntrue;MyString;My first extraordinary MOC;Very awesome;MyString;160 by 240;MyString;1;2;;cm;1.6;2.4;;1000;1;1;false;false;false;false;-\n", response.body.encode(Encoding::UTF_8)
  end
end
