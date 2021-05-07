require 'test_helper'

class UnitTest < ActiveSupport::TestCase

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
    assert_nil exhibit.size_z_meter
    assert_equal 80, exhibit.size_x_centimeter
    assert_equal 8, exhibit.size_y_centimeter
    assert_nil exhibit.size_z_centimeter
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
    assert_nil exhibit.size_z_meter
    assert_equal 100, exhibit.size_x_centimeter
    assert_equal 10, exhibit.size_y_centimeter
    assert_nil exhibit.size_z_centimeter
  end

  test "m" do
    m = units(:m)
    attendance = attendances(:one)
    # TODO: Size is INTEGER at the moment, which should be questioned...
    exhibit = Exhibit.new({ :attendance => attendance, :unit => m, :size_x => 1.333, :size_y => 1.51, :size_z => 1.666 })
    exhibit.save
    expected_messages = {}
    assert_equal expected_messages, exhibit.errors.messages
    assert exhibit.valid?, 'Exhibit should be valid'
    assert exhibit.errors.empty?
    #    assert_equal 1.333, exhibit.size_x_meter
    assert_equal 1, exhibit.size_x_meter
    #    assert_equal 1.51, exhibit.size_y_meter
    assert_equal 1, exhibit.size_y_meter
    #    assert_equal 1.666, exhibit.size_z_meter
    assert_equal 1, exhibit.size_z_meter
    #    assert_equal 133.3, exhibit.size_x_centimeter
    assert_equal 100, exhibit.size_x_centimeter
    #    assert_equal 151.0, exhibit.size_y_centimeter
    assert_equal 100, exhibit.size_y_centimeter
    #    assert_equal 166.6, exhibit.size_z_centimeter
    assert_equal 100, exhibit.size_z_centimeter
  end

end
