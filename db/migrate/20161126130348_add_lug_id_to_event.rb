class AddLugIdToEvent < ActiveRecord::Migration
  def change
    rename_column :events, :lug, :lugname
    add_column :events, :lug_id, :integer
  end
end
