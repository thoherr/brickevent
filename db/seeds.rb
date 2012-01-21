# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

bb2012 =
Event.create(:name => 'BB 2012',
             :title => 'Bricking Bavaria 2012',
             :description => 'Unsere Jahresausstellung 2011 im Rahmen des "LEGO® KidsFest"',
             :location => 'Event Arena im Olympiapark München',
             :url => 'http://bricking-bavaria.de/2012/bb2012/legoae-kidsfest-bricking-bavaria-2012',
             :lug => 'Bricking Bavaria e.V.',
             :registration_open => true,
             :start_date => '2012-04-12',
             :end_date => '2012-04-15')

ec_riemarcaden2012 =
Event.create(:name => 'Center-Ausstellung in den Riem Arcaden 2012',
             :title => 'Ausstellung im Einkaufcenter Riem Arcaden München',
             :description => 'Eine Centerausstellung, bei der die Modelle drei Wochen gezeigt werden',
             :location => 'Riem Arcaden München',
             :url => nil,
             :lug => 'Bricking Bavaria e.V.',
             :registration_open => false,
             :start_date => '2012-05-13',
             :end_date => '2012-06-03')

AccommodationType.create :name => 'Einzelzimmer', :description => 'Separates Einzelzimmer', :size => 1
AccommodationType.create :name => 'Doppelzimmer', :description => 'Doppelzimmer für zwei Personen', :size => 2
AccommodationType.create :name => 'Zimmergemeinschaft (anderer AFOL)', :description => 'Ein Bett in einem Doppelzimmer mit einem anderen AFOL', :size => 1
AccommodationType.create :name => 'Sonstiges (siehe Bemerkungen)', :description => 'Sonderwunsch, der im Bemerkungsfeld näher erläutert ist'

AttendeeType.create :name => 'Aussteller', :description => 'Teilnehmer der ein oder mehrere MOCs auf dieser Veranstaltung zeigt'
AttendeeType.create :name => 'Helfer', :description => 'Helfer, der kein eigenes MOC zeigt, aber an der Veranstaltung aktiv mitwirkt'
AttendeeType.create :name => 'Begleitperson', :description => 'Begleitpersonen, die nicht bei der Veranstaltung aktiv sind'
AttendeeType.create :name => 'Besucher', :description => 'Besucher, die nur vorbeischauen und am AFOLs-Event teilnehmen'

thomas = User.create :email => 'mail@thoherr.de', :name => 'Thomas Herrmann', :nickname => 'thoherr'
thomas.password = 'abc123'
thomas.is_admin = true
thomas.save
