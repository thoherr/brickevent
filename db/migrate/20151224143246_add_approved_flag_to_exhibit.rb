class AddApprovedFlagToExhibit < ActiveRecord::Migration[3.1]
  def change
    add_column :exhibits, :is_approved, :boolean
  end
end
