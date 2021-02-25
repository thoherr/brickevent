class AddMocSizeInCmToExhibits < ActiveRecord::Migration[3.1]
  def change
    add_column :exhibits, :size_x_meter, :decimal
    add_column :exhibits, :size_y_meter, :decimal
    add_column :exhibits, :size_z_meter, :decimal
  end
end
