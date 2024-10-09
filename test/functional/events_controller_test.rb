# encoding: utf-8

require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  setup do
    user = users(:one)
    user.confirm
    sign_in user
    @event = events(:one)
  end

  test "should get index" do
    get :index, params: {}
    assert_response :success
    assert_not_nil assigns(:events)
  end

  test "should show event" do
    @user = users(:thoherr)
    @user.confirm
    sign_in @user
    get :show, params: { id: @event.to_param }
    assert_response :success
  end

  test "non admins should not get attendees as csv for event" do
    assert_raise do
      get :attendees_as_csv, params: { id: events(:three).to_param }
    end
  end

  test "admin should get attendees as csv for event" do
    @user = users(:thoherr)
    @user.confirm
    sign_in @user
    get :attendees_as_csv, params: { id: events(:three).to_param }
    assert_response :success
    assert_equal "ID;Typ;Bestätigt;Name;LUG;Nickname;EMail;Telefon;Adresse;AFOLs-Abend;Ticket;Our wonderful first option;;Some weird thing;Another weird thing;;Bemerkungen;Anzahl Event-Shirts;Shirt-Größe;Zuletzt geändert\n101;Aussteller;false;Attendee1;LUG1;Nick1;;+49 171 5715348;Jeschkenstr. 49, 82538 Geretsried;true;true;false;false;false;false;false;Glad to see you;;;2018-07-30 00:00:00\n102;Aussteller;false;Attendee2;LUG1;Nick2;;MyString;MyString;false;false;true;false;false;true;false;Hi, there;2;2XL;2018-07-20 00:00:00\n103;Helfer;false;Attendee3;LUG2;Nick3;;+49 171 5715348;Jeschkenstr. 49, 82538 Geretsried;true;true;false;true;false;false;true;None;;;2018-06-21 00:00:00\n",response.body.encode(Encoding::UTF_8)
  end

  test "unauthorized user should not get exhibits as csv for event" do
    assert_raise do
      get :exhibits_as_csv, params: { id: events(:three).to_param }
    end
  end

  test "admin should get exhibits as csv for event" do
    @user = users(:thoherr)
    @user.confirm
    sign_in @user
    get :exhibits_as_csv, params: { id: events(:three).to_param }
    assert_response :success
    assert_equal "ID;Bestätigt;Name;Email;MOC;Beschreibung;Anmerkungen;URL;Größe x;Größe y;Größe z;Größe Einheit;Größe x (cm);Größe y (cm);Größe z (cm);Tisch;Position;Versicherungswert;Versicherungswert Anlage;Baustunden;Anzahl Steine;Strom?;Sammeltransport;Gemeinschaftsprojekt?;Teil Gemeinschaftsprojekt;Name Gemeinschaftsprojekt;Zuletzt geändert\n41;true;User One;user42@mytestdomain.de;My first extraordinary MOC;Very awesome;Very important remark;MyString;1;2;;m;160.0;240.0;;4;2;1000;0.0;1;1;false;false;false;false;-;2018-06-15 00:00:00\n42;false;Second user;second@mytestdomain.de;Another great MOC;Even more awesome 'the - killer, bla bla bla...' MOC;Need my own exhibit hall;MyString;24;64;;m;2400.0;6400.0;;;;10000000;0.0;10000;1000000;false;true;false;false;-;2018-07-10 00:00:00\n45;true;User One;user42@mytestdomain.de;Simple litte MOC;Quite awesome;;;0;0;;m;;;;;;123;0.0;;;;;false;true;-;2024-09-10 00:00:00\n",response.body.encode(Encoding::UTF_8)
  end
end
