class CopyMeterToCentimeter < ActiveRecord::Migration[6.1]
  def up
    Exhibit.all.each do |e|
      e.size_x_centimeter = e.size_x_meter * 100.0 unless e.size_x_meter.nil?
      e.size_y_centimeter = e.size_y_meter * 100.0 unless e.size_y_meter.nil?
      e.size_z_centimeter = e.size_z_meter * 100.0 unless e.size_z_meter.nil?
      e.save
    end
  end
  def down
    Exhibit.all.each do |e|
      e.size_x_meter = e.size_x_centimeter / 100.0 unless e.size_x_meter.nil?
      e.size_y_meter = e.size_y_centimeter / 100.0 unless e.size_x_meter.nil?
      e.size_z_meter = e.size_z_centimeter / 100.0 unless e.size_x_meter.nil?
      e.save
    end
  end
end
