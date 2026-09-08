# encoding: utf-8

require 'test_helper'

class EventTest < ActiveSupport::TestCase

  test "generate attendees csv" do
    event1 = events(:one)
    assert_equal "ID;Typ;Bestätigt;Vorname;Nachname;LUG;Nickname;EMail;Telefon;Adresse;AFOLs-Abend;Ticket;;;;;;Bemerkungen;Anzahl Event-Shirts;Shirt-Größe;Voucher;Bestell-Link;Bestellcode;Positions-ID;Bestellstatus;Ticket-Secret;Ticket-Link;Bestellung importiert;Zuletzt geändert\n",
                 event1.attendees_as_csv
    event3 = events(:three)
    assert_equal 3, event3.number_of_attendees
    assert_equal "ID;Typ;Bestätigt;Vorname;Nachname;LUG;Nickname;EMail;Telefon;Adresse;AFOLs-Abend;Ticket;Our wonderful first option;;Some weird thing;Another weird thing;;Bemerkungen;Anzahl Event-Shirts;Shirt-Größe;Voucher;Bestell-Link;Bestellcode;Positions-ID;Bestellstatus;Ticket-Secret;Ticket-Link;Bestellung importiert;Zuletzt geändert\n" +
                   "101;Aussteller;true;Attendee;One;LUG1;Nick1;;+49 171 5715348;Jeschkenstr. 49, 82538 Geretsried;true;true;false;false;false;false;false;Glad to see you;;;101-0F4C4A3E-1F2B-4C3D-8E9F-000000000101;https://pretix.example.com/lug1/ev3/redeem?voucher=101-0F4C4A3E-1F2B-4C3D-8E9F-000000000101;;;;;;;2018-07-30 00:00:00\n" +
                   "102;Aussteller;false;Attendee;Two;LUG1;Nick2;;MyString;MyString;false;false;true;false;false;true;false;Hi, there;2;2XL;102-0F4C4A3E-1F2B-4C3D-8E9F-000000000102;https://pretix.example.com/lug1/ev3/redeem?voucher=102-0F4C4A3E-1F2B-4C3D-8E9F-000000000102;;;;;;;2018-07-20 00:00:00\n" +
                   "103;Helfer;true;Attendee;Three;LUG2;Nick3;;+49 171 5715348;Jeschkenstr. 49, 82538 Geretsried;true;true;false;true;false;false;true;None;;;103-0F4C4A3E-1F2B-4C3D-8E9F-000000000103;https://pretix.example.com/lug1/ev3/redeem?voucher=103-0F4C4A3E-1F2B-4C3D-8E9F-000000000103;ABC12;1;paid;s3cr3tt1ck3t;https://pretix.example.com/lug1/ev3/ticket/ABC12/1/websecret/;2018-06-22 00:00:00;2018-06-21 00:00:00\n",
                 event3.attendees_as_csv
  end

  test "generate exhibits csv" do
    event1 = events(:one)
    assert_equal 0, event1.number_of_exhibits
    assert_equal "ID;Bestätigt;Vorname;Nachname;Email;MOC;Beschreibung;Anmerkungen;URL;Größe x;Größe y;Größe z;Größe Einheit;Größe x (cm);Größe y (cm);Größe z (cm);Tisch;Position;Versicherungswert;Versicherungswert Anlage;Baustunden;Anzahl Steine;Strom?;Sammeltransport;Gemeinschaftsprojekt?;Collab?;Teil Gemeinschaftsprojekt;Name Gemeinschaftsprojekt;Zuletzt geändert\n",
                 event1.exhibits_as_csv
    event3 = events(:three)
    assert_equal 3, event3.number_of_exhibits
    assert_equal "ID;Bestätigt;Vorname;Nachname;Email;MOC;Beschreibung;Anmerkungen;URL;Größe x;Größe y;Größe z;Größe Einheit;Größe x (cm);Größe y (cm);Größe z (cm);Tisch;Position;Versicherungswert;Versicherungswert Anlage;Baustunden;Anzahl Steine;Strom?;Sammeltransport;Gemeinschaftsprojekt?;Collab?;Teil Gemeinschaftsprojekt;Name Gemeinschaftsprojekt;Zuletzt geändert\n" +
                   "41;true;User;One;user42@mytestdomain.de;My first extraordinary MOC;Very awesome;Very important remark;https://mocone.example.com/pic.jpg;1;2;;m;160.0;240.0;;4;2;1000;0.0;1;1;false;false;false;false;false;-;2018-06-15 00:00:00\n" +
                   "42;false;Second;user;second@mytestdomain.de;Another great MOC;Even more awesome 'the - killer, bla bla bla...' MOC;Need my own exhibit hall;https://awesome.example.com/;24;64;;m;2400.0;6400.0;;;;10000000;0.0;10000;1000000;false;true;false;false;false;-;2018-07-10 00:00:00\n" +
                   "45;true;User;One;user42@mytestdomain.de;Simple small MOC;Quite awesome;;;0;0;;m;;;;;;123;0.0;;;;;false;false;true;-;2024-09-10 00:00:00\n",
                 event3.exhibits_as_csv
    event42 = events(:fourty_two)
    assert_equal 4, event42.number_of_exhibits
    assert_equal "ID;Bestätigt;Vorname;Nachname;Email;MOC;Beschreibung;Anmerkungen;URL;Größe x;Größe y;Größe z;Größe Einheit;Größe x (cm);Größe y (cm);Größe z (cm);Tisch;Position;Versicherungswert;Versicherungswert Anlage;Baustunden;Anzahl Steine;Strom?;Sammeltransport;Gemeinschaftsprojekt?;Collab?;Teil Gemeinschaftsprojekt;Name Gemeinschaftsprojekt;Zuletzt geändert\n" +
                   "6;true;Second;user;second@mytestdomain.de;A Collab;;;;;;;cm;;;;;;0.0;;;;;;true;true;;-;2024-10-11 00:00:00\n" +
                   "7;true;Second;user;second@mytestdomain.de;Part of Collab;;;;;;;cm;;;;;;;0.0;;;;;;false;true;A Collab;2024-10-11 00:00:00\n" +
                   "44;false;Thomas;Herrmann;mail@thoherr.de;StarWars Installation;This is our SW Installation MOC;;https://moc3.example.com/;100;200;;m;10000.0;20000.0;;7;;0.0;1234;;;;;true;false;false;-;2021-05-04 00:00:00\n" +
                   "48;true;Thomas;Herrmann;mail@thoherr.de;Part of Installation MOC;Small but beautiful;;;0;0;;m;;;;;;456;0.0;;;;;false;false;true;StarWars Installation;2024-10-10 00:00:00\n",
                 event42.exhibits_as_csv
  end

  test "generate voting cards" do
    Prawn::Fonts::AFM.hide_m17n_warning = true
    zip = VotingPosterZipfileCreation.new(events(:fourty_two)).call
    assert_not_empty zip
    Zip::InputStream.open(StringIO.new(zip)) do |io|
      assert_equal "COLLAB-voting-6--.pdf", io.get_next_entry.name
      assert_equal "MOC-voting-48-7.pdf", io.get_next_entry.name
      assert_nil io.get_next_entry
    end
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

  test "import valid csv file" do
    event3 = events(:three)
    import = CsvExhibitImport.call(event3, file_fixture('exhibit_import_valid.csv'))
    assert_equal 4, import.size
    assert_equal 3, import[:success_count]
    assert_equal 0, import[:failure_count]
    assert_equal [], import[:errors]
    assert_equal 0, import[:ignore_count]
  end

  test "import invalid csv file" do
    event3 = events(:three)
    import = CsvExhibitImport.call(event3, file_fixture('exhibit_import_invalid.csv'))
    assert_equal 4, import.size
    assert_equal 3, import[:success_count]
    assert_equal 3, import[:failure_count]
    assert_equal ["44", "95", "48"], import[:errors]
    assert_equal 3, import[:ignore_count]
  end

  test "import corrupt csv file" do
    event3 = events(:three)
    import = CsvExhibitImport.call(event3, file_fixture('exhibit_import_corrupt.csv'))
    assert_equal 4, import.size
    assert_equal 3, import[:success_count]
    assert_equal 2, import[:failure_count]
    assert_equal ["44", "48"], import[:errors]
    assert_equal 7, import[:ignore_count]
  end

  test "event should only accept sane event URLs" do
    event = events(:fourty_two)
    assert event.valid?
    event.url = 'http://example.com'
    assert event.valid?
    event.url = 'javascript://example.com/test.js'
    assert_not event.valid?
    event.url = 'https://example.com'
    assert event.valid?
    event.url = 'blablubb://example.com'
    assert_not event.valid?
  end

  test "event should only accept sane logo URLs" do
    event = events(:fourty_two)
    assert event.valid?
    event.logo_url = 'http://example.com'
    assert event.valid?
    event.logo_url = 'blablubb://example.com'
    assert_not event.valid?

    event = events(:three)
    assert event.valid?
    event.logo_url = 'javascript://example.com/test.js'
    assert_not event.valid?
    event.logo_url = 'https://example.com'
    assert event.valid?
  end

  test "shop configuration" do
    assert events(:three).shop_configured?
    assert_equal "https://pretix.example.com/lug1/ev3/", events(:three).shop_base_url
    assert_not events(:one).shop_configured?
    assert_nil events(:one).shop_base_url
    event = Event.new(shop_url: "https://pretix.example.com/lug1/ev3")
    assert_equal "https://pretix.example.com/lug1/ev3/", event.shop_base_url
  end

  test "shop url must be a http(s) url" do
    event = events(:three)
    event.shop_url = "javascript:alert(1)"
    assert_not event.valid?
    event.shop_url = ""
    assert event.valid?
  end

  test "vouchers as csv exports new vouchers once" do
    event = events(:three)
    header = "ID;Vorname;Nachname;EMail;Voucher\n"
    expected = header +
               "101;Attendee;One;mail@thoherr.de;101-0F4C4A3E-1F2B-4C3D-8E9F-000000000101\n" +
               "102;Attendee;Two;second@mytestdomain.de;102-0F4C4A3E-1F2B-4C3D-8E9F-000000000102\n" +
               "103;Attendee;Three;mail@thoherr.de;103-0F4C4A3E-1F2B-4C3D-8E9F-000000000103\n"

    assert_equal expected, event.vouchers_as_csv
    assert event.attendees.reload.all? { |a| a.voucher_exported_at.present? }

    assert_equal header, event.vouchers_as_csv, "second export contains no new vouchers"
    assert_equal expected, event.vouchers_as_csv(only_new: false)
  end
end
