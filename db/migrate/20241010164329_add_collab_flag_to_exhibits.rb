class AddCollabFlagToExhibits < ActiveRecord::Migration[7.2]
  def change
    add_column :exhibits, :is_collab, :boolean, :default => false
    Exhibit.where(is_installation: true).each { |e | e.update_attribute(:is_collab, true) }
  end
end
