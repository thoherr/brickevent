class AddMocSizeToExhibits < ActiveRecord::Migration[4.2]
  def change
    add_column :exhibits, :size_x, :integer
    add_column :exhibits, :size_y, :integer
    add_column :exhibits, :size_z, :integer
    add_column :exhibits, :unit_id, :integer
  end
end
