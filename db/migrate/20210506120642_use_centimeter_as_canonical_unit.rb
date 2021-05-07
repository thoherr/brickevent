class UseCentimeterAsCanonicalUnit < ActiveRecord::Migration[6.1]
  def change
    add_column :exhibits, :size_x_centimeter, :decimal, precision: 6, scale: 1
    add_column :exhibits, :size_y_centimeter, :decimal, precision: 6, scale: 1
    add_column :exhibits, :size_z_centimeter, :decimal, precision: 6, scale: 1
  end
end
