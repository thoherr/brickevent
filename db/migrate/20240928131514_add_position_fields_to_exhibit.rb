class AddPositionFieldsToExhibit < ActiveRecord::Migration[7.2]
  def change
    add_column :exhibits, :platform, :integer
    add_column :exhibits, :position, :integer
  end
end
