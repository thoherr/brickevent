# encoding: UTF-8

require 'test_helper'

class EventTest < ActiveSupport::TestCase

  test "generate attendees csv" do
    event1 = events(:one)
    assert_equal "Typ;Bestätigt;Name;LUG;Nickname;EMail;AFOLs-Abend;Bemerkungen;T-Shirt-Größe\n", event1.attendees_as_csv
    event3 = events(:three)
    assert_equal 3, event3.number_of_attendees
    assert_equal "Typ;Bestätigt;Name;LUG;Nickname;EMail;AFOLs-Abend;Bemerkungen;T-Shirt-Größe\nHelfer;false;Attendee3;LUG2;Nick3;;true;None;\nAussteller;false;Attendee2;LUG1;Nick2;;false;Hi, there;\nAussteller;false;Attendee1;LUG1;Nick1;;true;Glad to see you;\n", event3.attendees_as_csv
  end

  test "generate exhibits csv" do
    event1 = events(:one)
    assert_equal "Bestätigt;Name;MOC;Beschreibung;URL;Größe in Studs;Größe;Größe x;Größe y;Größe z;Größe Einheit;Größe x (m);Größe y (m);Größe z (m);Versicherungswert;Baustunden;Anzahl Steine;Strom?;Sammeltransport;Gemeinschaftsprojekt?;Teil Gemeinschaftsprojekt;Name Gemeinschaftsprojekt\n", event1.exhibits_as_csv
    event3 = events(:three)
    assert_equal 2, event3.number_of_exhibits
    assert_equal "Bestätigt;Name;MOC;Beschreibung;URL;Größe in Studs;Größe;Größe x;Größe y;Größe z;Größe Einheit;Größe x (m);Größe y (m);Größe z (m);Versicherungswert;Baustunden;Anzahl Steine;Strom?;Sammeltransport;Gemeinschaftsprojekt?;Teil Gemeinschaftsprojekt;Name Gemeinschaftsprojekt\nfalse;MyString;Another great MOC;Even more awesome;MyString;2400 * 6400;Huge;24;64;;cm;24.0;64.0;;10;10.0;1;false;true;false;false;-\ntrue;MyString;My first extraordinary MOC;Very awesome;MyString;160 by 240;MyString;1;2;;cm;1.6;2.4;;1000;1;1;false;false;false;false;-\n", event3.exhibits_as_csv
  end

  test "calculate total size" do
    event3 = events(:three)
    assert_equal 1539.84, event3.size_square_meters_registered
    assert_equal 1540.00, event3.required_space_square_meters_registered
    assert_equal 3.84, event3.size_square_meters_approved
    assert_equal 4.00, event3.required_space_square_meters_approved
  end

end
