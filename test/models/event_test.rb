# encoding: utf-8

require 'test_helper'

class EventTest < ActiveSupport::TestCase

  test "generate attendees csv" do
    event1 = events(:one)
    assert_equal "ID;Typ;Bestätigt;Name;LUG;Nickname;EMail;Telefon;Adresse;AFOLs-Abend;Ticket;;;;;;Bemerkungen;Anzahl Event-Shirts;Shirt-Größe;Zuletzt geändert\n", event1.attendees_as_csv
    event3 = events(:three)
    assert_equal 3, event3.number_of_attendees
    assert_equal "ID;Typ;Bestätigt;Name;LUG;Nickname;EMail;Telefon;Adresse;AFOLs-Abend;Ticket;Our wonderful first option;;Some weird thing;Another weird thing;;Bemerkungen;Anzahl Event-Shirts;Shirt-Größe;Zuletzt geändert\n101;Aussteller;false;Attendee1;LUG1;Nick1;;+49 171 5715348;Jeschkenstr. 49, 82538 Geretsried;true;true;false;false;false;false;false;Glad to see you;;;2018-07-30 00:00:00\n102;Aussteller;false;Attendee2;LUG1;Nick2;;MyString;MyString;false;false;true;false;false;true;false;Hi, there;2;2XL;2018-07-20 00:00:00\n103;Helfer;false;Attendee3;LUG2;Nick3;;+49 171 5715348;Jeschkenstr. 49, 82538 Geretsried;true;true;false;true;false;false;true;None;;;2018-06-21 00:00:00\n", event3.attendees_as_csv
  end

  test "generate exhibits csv" do
    event1 = events(:one)
    assert_equal "ID;Bestätigt;Name;MOC;Beschreibung;Anmerkungen;URL;Größe x;Größe y;Größe z;Größe Einheit;Größe x (m);Größe y (m);Größe z (m);Versicherungswert;Baustunden;Anzahl Steine;Strom?;Sammeltransport;Gemeinschaftsprojekt?;Teil Gemeinschaftsprojekt;Name Gemeinschaftsprojekt;Zuletzt geändert\n", event1.exhibits_as_csv
    event3 = events(:three)
    assert_equal 2, event3.number_of_exhibits
    assert_equal "ID;Bestätigt;Name;MOC;Beschreibung;Anmerkungen;URL;Größe x;Größe y;Größe z;Größe Einheit;Größe x (m);Größe y (m);Größe z (m);Versicherungswert;Baustunden;Anzahl Steine;Strom?;Sammeltransport;Gemeinschaftsprojekt?;Teil Gemeinschaftsprojekt;Name Gemeinschaftsprojekt;Zuletzt geändert\n41;true;MyString;My first extraordinary MOC;Very awesome;Very important remark;MyString;1;2;;cm;1.6;2.4;;1000;1;1;false;false;false;false;-;2018-06-15 00:00:00\n42;false;MyString;Another great MOC;Even more awesome 'the - killer, bla bla bla...' MOC;Need my own exhibit hall;MyString;24;64;;cm;24.0;64.0;;10;10.0;1;false;true;false;false;-;2018-07-10 00:00:00\n", event3.exhibits_as_csv
  end

  test "calculate total size" do
    event3 = events(:three)
    assert_equal 1539.84, event3.size_square_meters_registered
    assert_equal 1542.00, event3.required_space_square_meters_registered
    assert_equal 3.84, event3.size_square_meters_approved
    assert_equal 6.00, event3.required_space_square_meters_approved
  end

  test "check event manager" do
    event = events(:one)
    user1 = users(:one)
    user2 = users(:thoherr)
    assert_equal false, event.is_managed_by?(user1)
    assert_equal true, event.is_managed_by?(user2)
    assert_equal false, event.is_managed_by?(nil)
  end

end
