class UpdateFactorForCm < ActiveRecord::Migration[6.1]
  def up
    rename_column :units, :factor, :centimeter
    Unit.all.each do |u|
      u.centimeter = u.centimeter * 100.0
      u.save
    end
  end

  def down
    rename_column :units, :centimeter, :factor
    Unit.all.each do |u|
      u.factor = u.factor / 100.0
      u.save
    end
  end
end
