require "test_helper"

class VoteTest < ActiveSupport::TestCase
  test "PUBLIC_VOTES constant returns 'public'" do
    assert_equal 'public', Vote.PUBLIC_VOTES
  end

  test "ATTENDEES_VOTES constant returns 'attendees'" do
    assert_equal 'attendees', Vote.ATTENDEES_VOTES
  end

  test "Vote model exists and can be instantiated" do
    assert_nothing_raised do
      Vote.new
    end
  end
end
