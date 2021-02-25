class AddAcceptDataStorageForUser < ActiveRecord::Migration[3.1]
  def up
    change_table(:users) do |t|
      t.boolean :accept_data_storage
    end
  end

  def down
    remove_column :users, :accept_data_storage
  end
end
