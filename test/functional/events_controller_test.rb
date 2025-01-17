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
    assert_equal "ID;Typ;Bestätigt;Name;LUG;Nickname;EMail;Telefon;Adresse;AFOLs-Abend;Ticket;Our wonderful first option;;Some weird thing;Another weird thing;;Bemerkungen;Anzahl Event-Shirts;Shirt-Größe;Zuletzt geändert\n" +
                   "101;Aussteller;false;Attendee1;LUG1;Nick1;;+49 171 5715348;Jeschkenstr. 49, 82538 Geretsried;true;true;false;false;false;false;false;Glad to see you;;;2018-07-30 00:00:00\n" +
                   "102;Aussteller;false;Attendee2;LUG1;Nick2;;MyString;MyString;false;false;true;false;false;true;false;Hi, there;2;2XL;2018-07-20 00:00:00\n" +
                   "103;Helfer;false;Attendee3;LUG2;Nick3;;+49 171 5715348;Jeschkenstr. 49, 82538 Geretsried;true;true;false;true;false;false;true;None;;;2018-06-21 00:00:00\n",
                 response.body.encode(Encoding::UTF_8)
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
    assert_equal "ID;Bestätigt;Name;Email;MOC;Beschreibung;Anmerkungen;URL;Größe x;Größe y;Größe z;Größe Einheit;Größe x (cm);Größe y (cm);Größe z (cm);Tisch;Position;Versicherungswert;Versicherungswert Anlage;Baustunden;Anzahl Steine;Strom?;Sammeltransport;Gemeinschaftsprojekt?;Collab?;Teil Gemeinschaftsprojekt;Name Gemeinschaftsprojekt;Zuletzt geändert\n" +
                   "41;true;User One;user42@mytestdomain.de;My first extraordinary MOC;Very awesome;Very important remark;https://mocone.example.com/pic.jpg;1;2;;m;160.0;240.0;;4;2;1000;0.0;1;1;false;false;false;false;false;-;2018-06-15 00:00:00\n" +
                   "42;false;Second user;second@mytestdomain.de;Another great MOC;Even more awesome 'the - killer, bla bla bla...' MOC;Need my own exhibit hall;https://awesome.example.com/;24;64;;m;2400.0;6400.0;;;;10000000;0.0;10000;1000000;false;true;false;false;false;-;2018-07-10 00:00:00\n" +
                   "45;true;User One;user42@mytestdomain.de;Simple small MOC;Quite awesome;;;0;0;;m;;;;;;123;0.0;;;;;false;false;true;-;2024-09-10 00:00:00\n",
                 response.body.encode(Encoding::UTF_8)
  end

  test "authorized user should be able to upload csv data" do
    @user = users(:thoherr)
    @user.confirm
    sign_in @user

    event = events(:three)
    post :csv_import,
         params: { id: event.id,
                   file: file_fixture_upload('exhibit_import_valid.csv',
                                             'text/csv') }
    assert_redirected_to event_path(event)
    assert_equal I18n.t('moc_data_imported_stats_notice', import: 0, import2: 0, import3: 3), flash[:notice]
    assert_nil flash[:alert]

    post :csv_import,
         params: { id: event.id,
                   file: file_fixture_upload('exhibit_import_invalid.csv',
                                             'text/csv') }
    assert_redirected_to event_path(event)
    assert_equal I18n.t('moc_data_imported_stats_notice', import: 3, import2: 3, import3: 3), flash[:notice]
    assert_equal I18n.t('failed_moc_ids', inspect: "[\"44\", \"95\", \"48\"]"), flash[:alert]

    post :csv_import,
         params: { id: event.id,
                   file: file_fixture_upload('exhibit_import_corrupt.csv',
                                             'text/csv') }
    assert_redirected_to event_path(event)
    assert_equal I18n.t('moc_data_imported_stats_notice', import: 7, import2: 2, import3: 3), flash[:notice]
    assert_equal I18n.t('failed_moc_ids', inspect: "[\"44\", \"48\"]"), flash[:alert]

  end

end
