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
             :url => 'http://www.lego-kids-fest.de/',
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

thomasH = User.create :email => 'mail@thoherr.de', :name => 'Thomas Herrmann', :nickname => 'thoherr'
thomasH.password = 'abc123'
thomasH.is_admin = true
thomasH.save

thomasN = User.create :email => 'tom@tom-online.de', :name => 'Thomas Nickolaus'
thomasN.password = 'bb2012'
thomasN.is_admin = true
thomasN.save

juergen = User.create :email => 'juergen.bartosch@billing-components.de', :name => 'Juergen Bartosch'
juergen.password = 'bb2012'
juergen.is_admin = true
juergen.save

christina = User.create :email => 'ohyear@web.de', :name => 'Christina Iglhaut'
christina.password = 'bb2012'
christina.is_admin = true
christina.save

gerd = User.create :email => 'momkage-mb@t-online.de', :name => 'Gerd Mombrei'
gerd.password = 'bb2012'
gerd.is_admin = true
gerd.save

