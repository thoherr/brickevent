require 'test_helper'

class UnitTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "studs" do
    studs = units(:studs)
    exhibit = exhibits(:one)
    exhibit.unit = studs
    exhibit.size_x = 100
    exhibit.size_y = 10
    exhibit.save
    expected_messages = {}
    assert_equal expected_messages, exhibit.errors.messages
    assert exhibit.valid?, 'Exhibit should be valid'
    assert exhibit.errors.empty?
    assert_equal 0.80, exhibit.size_x_meter
    assert_equal 0.08, exhibit.size_y_meter
  end

  test "cm" do
    cm = units(:cm)
    attendance = attendances(:one)
    exhibit = Exhibit.new({ :attendance => attendance, :unit => cm, :size_x => 100, :size_y => 10 })
    exhibit.save
    expected_messages = {}
    assert_equal expected_messages, exhibit.errors.messages
    assert exhibit.valid?, 'Exhibit should be valid'
    assert exhibit.errors.empty?
    assert_equal 1, exhibit.size_x_meter
    assert_equal 0.1, exhibit.size_y_meter
  end

end
