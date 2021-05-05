class AddLogoUrlToEvent < ActiveRecord::Migration[4.2]
  def up
    change_table(:events) do |t|
      t.string :logo_url
    end
  end
  def down
    remove_column :events, :logo_url
  end
end
