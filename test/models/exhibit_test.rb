require 'test_helper'

class ExhibitTest < ActiveSupport::TestCase
  test "copy for new attendance" do
    exhibit = exhibits(:one)
    exhibit_copy = exhibit.copy_for_new_attendance
    new_exhibit = Exhibit.new(id: nil, attendance_id: nil, name: "My first extraordinary MOC", description: "Very awesome", url: "MyString", size_studs: nil, size: nil, value: 1000, building_hours: "1", brick_count: 1, needs_power_supply: false, needs_transportation: false, is_installation: false, is_part_of_installation: false, installation_exhibit_id: nil, remarks: "Very important remark", created_at: nil, updated_at: nil, size_x: 1, size_y: 2, size_z: nil, unit_id: 708722920, size_x_meter: 0.16e1, size_y_meter: 0.24e1, size_z_meter: nil, former_exhibit_id: 41, is_approved: false)
    assert_equal new_exhibit.inspect, exhibit_copy.inspect
  end
end
