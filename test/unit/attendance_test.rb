require 'test_helper'


class AttendanceTest < ActiveSupport::TestCase

  setup do
    @event = events(:one)
    @user = users(:one)
    @attendee_type = attendee_types(:one)
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

end
