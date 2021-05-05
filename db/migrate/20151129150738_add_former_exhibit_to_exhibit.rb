class AddFormerExhibitToExhibit < ActiveRecord::Migration[4.2]
  def change
    add_column :exhibits, :former_exhibit_id, :integer
  end
end
