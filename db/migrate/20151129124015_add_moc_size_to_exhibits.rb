class AddMocSizeToExhibits < ActiveRecord::Migration[3.1]
  def change
    add_column :exhibits, :size_x, :integer
    add_column :exhibits, :size_y, :integer
    add_column :exhibits, :size_z, :integer
    add_column :exhibits, :unit_id, :integer
  end
end
