class AddApprovedFlagToExhibit < ActiveRecord::Migration[4.2]
  def change
    add_column :exhibits, :is_approved, :boolean
  end
end
