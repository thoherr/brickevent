class RenameColumnTableToPlatform < ActiveRecord::Migration[7.2]
  def change
    rename_column :exhibits, :table, :platform
  end
end
