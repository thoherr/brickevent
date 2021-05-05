require 'test_helper'


class AttendanceTest < ActiveSupport::TestCase

  setup do
    @event = events(:one)
    @event2 = events(:two)
    @user = users(:one)
    @attendee_type = attendee_types(:one)
    @unit = units(:cm)
  end

  # test "the truth" do
  #   assert true
  # end

  test "create an attendance" do
    assert_difference('Attendance.count') do
      @myattendance = Attendance.create(:user => @user, :event => @event)
    end
  end

  test "add attendees to attendance" do
    @myattendance = Attendance.create(:user => @user, :event => @event)
    assert_difference('@myattendance.attendees.count') do
      @myattendance.attendees << Attendee.create( :attendee_type => @attendee_type, :name => 'Marius' )
    end
  end

  test "add exhibits" do
    @myattendance = Attendance.create(:user => @user, :event => @event)
    expected_messages = {}
    assert_equal expected_messages, @myattendance.errors.messages
    assert_difference('@myattendance.exhibits.count') do
      @myattendance.exhibits.create( :name => "My MOC", :unit => @unit, :size_x => 20, :size_y => 30 )
      expected_messages = {}
      assert_equal expected_messages, @myattendance.errors.messages
      assert @myattendance.errors.empty?
      assert @myattendance.valid?, 'Attendance should be valid'
    end
  end

  test "copy exhibits" do
    @firstattendance = Attendance.create(:user => @user, :event => @event)
    assert_difference('@firstattendance.exhibits.count') do
      @firstattendance.exhibits << Exhibit.create( :name => "My MOC", :unit => @unit, :size_x => 50, :size_y => 25 )
    end
    @secondattendance = Attendance.create(:user => @user, :event => @event2)
    assert_difference('@secondattendance.exhibits.count') do
      @secondattendance.copy_exhibits! @firstattendance
    end
  end

end
