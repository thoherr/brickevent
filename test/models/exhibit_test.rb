require 'test_helper'

class ExhibitTest < ActiveSupport::TestCase
  test "copy for new attendance" do
    exhibit = exhibits(:one)
    exhibit_copy = exhibit.copy_for_new_attendance
    meter = units(:m)
    new_exhibit = Exhibit.new(id: nil, attendance_id: nil, name: "My first extraordinary MOC", description: "Very awesome", url: "MyString", size_studs: nil, size: nil, value: 1000, building_hours: "1", brick_count: 1, needs_power_supply: false, needs_transportation: false, is_installation: false, is_part_of_installation: false, installation_exhibit_id: nil, remarks: "Very important remark", created_at: nil, updated_at: nil, size_x: 1, size_y: 2, size_z: nil, unit_id: meter.id, size_x_meter: 0.16e1, size_y_meter: 0.24e1, size_z_meter: nil, size_x_centimeter: 0.16e3, size_y_centimeter: 0.24e3, size_z_centimeter: nil, former_exhibit_id: 41, is_approved: false, platform: 4, position: 2)
    assert_equal new_exhibit.inspect, exhibit_copy.inspect
  end

  test "print exhibit position" do
    exhibit = exhibits(:one)
    assert_equal "4.2", exhibit.platform_position
    exhibit = exhibits(:two)
    assert_equal "x.x", exhibit.platform_position
    exhibit = exhibits(:four)
    assert_equal "5.x (x.x)", exhibit.platform_position
  end
end
