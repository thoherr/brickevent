require 'test_helper'

class UnitTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "studs" do
    studs = Unit.find_by_name('studs')
    exhibit = Exhibit.new({ :unit => studs, :size_x => 100, :size_y => 10 })
    exhibit.save
    assert_equal exhibit.size_x_meter, 0.80
    assert_equal exhibit.size_y_meter, 0.08
  end

  test "cm" do
    cm = Unit.find_by_name('cm')
    exhibit = Exhibit.new({ :unit => cm, :size_x => 100, :size_y => 10 })
    exhibit.save
    assert_equal exhibit.size_x_meter, 1
    assert_equal exhibit.size_y_meter, 0.1
  end

end
