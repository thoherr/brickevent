class AddFormerExhibitToExhibit < ActiveRecord::Migration
  def change
    add_column :exhibits, :former_exhibit_id, :integer
  end
end
