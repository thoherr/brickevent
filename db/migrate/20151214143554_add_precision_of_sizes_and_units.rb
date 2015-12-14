class AddPrecisionOfSizesAndUnits < ActiveRecord::Migration
  def up
    change_column :exhibits, :size_x_meter, :decimal, :precision => 7, :scale => 2
    change_column :exhibits, :size_y_meter, :decimal, :precision => 7, :scale => 2
    change_column :exhibits, :size_z_meter, :decimal, :precision => 7, :scale => 2
    change_column :units, :factor, :decimal, :precision => 7, :scale => 5
    cm = Unit.find_by_name('cm')
    cm.factor = 0.01
    cm.save
    m = Unit.find_by_name('m')
    m.factor = 1.00
    m.save
    studs = Unit.find_by_name('studs')
    studs.factor = 0.008
    studs.save
    plate16 = Unit.find_by_name('plate16')
    plate16.factor = (16 * 0.008)
    plate16.save
    plate32 = Unit.find_by_name('plate32')
    plate32.factor = (32 * 0.008)
    plate32.save
    plate48 = Unit.find_by_name('plate48')
    plate48.factor = (48 * 0.008)
    plate48.save
  end

  def down
  end
end
