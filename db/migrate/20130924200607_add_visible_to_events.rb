class AddVisibleToEvents < ActiveRecord::Migration[3.1]
  def change
    add_column :events, :visible, :boolean
  end
end
