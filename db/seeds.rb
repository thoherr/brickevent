# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

bb2011 =
Event.create(:name => 'BB 2011',
             :title => 'Bricking Bavaria 2011',
             :description => 'Unsere Jahresausstellung 2011 als Teil der Messe "Freizeitspass hoch 3"',
             :location => 'M,O,C, München',
             :url => 'http://bricking-bavaria.de/2011/bb2011',
             :lug => 'Bricking Bavaria e.V.',
             :registration_open => true,
             :start_date => '2011-11-04',
             :end_date => '2011-11-06')

ec_bamberg2011 =
Event.create(:name => 'Bamberg 2011',
             :title => 'Ausstellung im Einkaufcenter Bamberg',
             :description => 'Eine Centerausstellung, bei der die Modelle zwei Wochen gezeigt werden',
             :location => 'Einkaufcenter Bamberg',
             :url => 'http://bricking-bavaria.de/2011/bamberg2011',
             :lug => 'Bricking Bavaria e.V.',
             :registration_open => true,
             :start_date => '2011-09-26',
             :end_date => '2011-10-08')

AccommodationType.create :name => 'Einzelzimmer', :description => 'Separates Einzelzimmer', :size => 1
AccommodationType.create :name => 'Doppelzimmer', :description => 'Doppelzimmer für zwei Personen', :size => 2
AccommodationType.create :name => 'Zimmergemeinschaft (anderer AFOL)', :description => 'Ein Bett in einem Doppelzimmer mit einem anderen AFOL', :size => 1
AccommodationType.create :name => 'Sonstiges (siehe Bemerkungen)', :description => 'Sonderwunsch, der im Bemerkungsfeld näher erläutert ist'

AttendeeType.create :name => 'Aussteller', :description => 'Teilnehmer der ein oder mehrere MOCs auf dieser Veranstaltung zeigt'
AttendeeType.create :name => 'Helfer', :description => 'Helfer, der kein eigenes MOC zeigt, aber an der Veranstaltung aktiv mitwirkt'
AttendeeType.create :name => 'Begleitperson', :description => 'Begleitpersonen, die nicht bei der Veranstaltung aktiv sind'
AttendeeType.create :name => 'Besucher', :description => 'Besucher, die nur vorbeischauen und am AFOLs-Event teilnehmen'

User.create :email => 'mail@thoherr.de', :passwort => 'abc123', :is_admin => true, :name => 'Thomas Herrmann', :nickname => 'thoherr'
