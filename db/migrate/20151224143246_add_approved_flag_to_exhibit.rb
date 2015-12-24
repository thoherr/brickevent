class AddApprovedFlagToExhibit < ActiveRecord::Migration
  def change
    add_column :exhibits, :is_approved, :boolean
  end
end
