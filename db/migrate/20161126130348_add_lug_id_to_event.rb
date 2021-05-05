class AddLugIdToEvent < ActiveRecord::Migration[4.2]
  def change
    rename_column :events, :lug, :lugname
    add_column :events, :lug_id, :integer
  end
end
