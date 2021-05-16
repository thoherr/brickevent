class ConvertUnitsToCm < ActiveRecord::Migration[6.1]
  def up
    change_column :units, :centimeter, :decimal, precision: 7, scale: 4
    Unit.all.each do |u|
      u.centimeter = u.centimeter * 100.0
      u.save
    end
  end

  def down
    Unit.all.each do |u|
      u.factor = u.factor / 100.0
      u.save
    end
  end
end
