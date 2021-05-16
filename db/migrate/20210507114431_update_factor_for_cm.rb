class UpdateFactorForCm < ActiveRecord::Migration[6.1]
  def up
    rename_column :units, :factor, :centimeter
  end

  def down
    rename_column :units, :centimeter, :factor
  end
end
