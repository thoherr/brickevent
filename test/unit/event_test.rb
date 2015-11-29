# encoding: UTF-8

require 'test_helper'

class EventTest < ActiveSupport::TestCase

  test "generate attendees csv" do
    event1 = events(:one)
    assert_equal "Typ;Name;LUG;Nickname;EMail;AFOLs-Abend;Bemerkungen;T-Shirt-Größe\n", event1.attendees_as_csv
    event3 = events(:three)
    assert_equal 3, event3.number_of_attendees
    assert_equal "Typ;Name;LUG;Nickname;EMail;AFOLs-Abend;Bemerkungen;T-Shirt-Größe\nHelfer;Attendee3;LUG2;Nick3;;true;None;\nAussteller;Attendee2;LUG1;Nick2;;false;Hi, there;\nAussteller;Attendee1;LUG1;Nick1;;true;Glad to see you;\n", event3.attendees_as_csv
  end

  test "generate exhibits csv" do
    event1 = events(:one)
    assert_equal "Name;MOC;Beschreibung;URL;Größe in Studs;Größe;Größe x;Größe y;Größe z;Größe Einheit;Größe x (m);Größe y (m);Größe z (m);Versicherungswert;Baustunden;Anzahl Steine;Strom?;Sammeltransport;Gemeinschaftsprojekt?;Teil Gemeinschaftsprojekt;Name Gemainschaftsprojekt\n", event1.exhibits_as_csv
    event3 = events(:three)
    assert_equal 2, event3.number_of_exhibits
    assert_equal "Name;MOC;Beschreibung;URL;Größe in Studs;Größe;Größe x;Größe y;Größe z;Größe Einheit;Größe x (m);Größe y (m);Größe z (m);Versicherungswert;Baustunden;Anzahl Steine;Strom?;Sammeltransport;Gemeinschaftsprojekt?;Teil Gemeinschaftsprojekt;Name Gemainschaftsprojekt\nMyString;Another great MOC;Even more awesome;MyString;2400 * 6400;Huge;2400;6400;;studs;;;;10;10.0;1;false;true;false;false;-\nMyString;My first extraordinary MOC;Very awesome;MyString;160 by 240;MyString;160;240;;studs;;;;1000;1;1;false;false;false;false;-\n", event3.exhibits_as_csv
  end

end
