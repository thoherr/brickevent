class AddFormerExhibitToExhibit < ActiveRecord::Migration[3.1]
  def change
    add_column :exhibits, :former_exhibit_id, :integer
  end
end
