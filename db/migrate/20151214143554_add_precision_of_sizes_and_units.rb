class AddPrecisionOfSizesAndUnits < ActiveRecord::Migration[4.2]
  def up
    change_column :exhibits, :size_x_meter, :decimal, :precision => 7, :scale => 2
    change_column :exhibits, :size_y_meter, :decimal, :precision => 7, :scale => 2
    change_column :exhibits, :size_z_meter, :decimal, :precision => 7, :scale => 2
    change_column :units, :factor, :decimal, :precision => 7, :scale => 5
    cm = Unit.find_by_name('cm')
    cm = Unit.new({ :name => 'cm', :description => 'Zentimeter', :factor => 0.01 }) if cm.nil?
    cm.factor = 0.01
    cm.save
    m = Unit.find_by_name('m')
    m = Unit.new({ :name => 'm', :description => 'Meter', :factor => 1.00 }) if m.nil?
    m.factor = 1.00
    m.save
    studs = Unit.find_by_name('studs')
    studs = Unit.new({ :name => 'studs', :description => 'Noppen', :factor => 0.008 }) if studs.nil?
    studs.factor = 0.008
    studs.save
    plate16 = Unit.find_by_name('plate16')
    plate16 = Unit.new({ :name => 'plate16', :description => '16er Platten', :factor => (16 * 0.008) }) if plate16.nil?
    plate16.factor = (16 * 0.008)
    plate16.save
    plate32 = Unit.find_by_name('plate32')
    plate32 = Unit.new({ :name => 'plate32', :description => '32er Platten', :factor => (32 * 0.008) }) if plate32.nil?
    plate32.factor = (32 * 0.008)
    plate32.save
    plate48 = Unit.find_by_name('plate48')
    plate48 = Unit.new({ :name => 'plate48', :description => '48er Platten', :factor => (48 * 0.008) }) if plate48.nil?
    plate48.factor = (48 * 0.008)
    plate48.save
  end

  def down
  end
end
