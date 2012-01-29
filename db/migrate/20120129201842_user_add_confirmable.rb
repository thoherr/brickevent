class UserAddConfirmable < ActiveRecord::Migration
  def self.up
    change_table(:users) do |t|
      t.confirmable
    end

    add_index :users, :confirmation_token,   :unique => true
  end

  def self.down
    remove_index  :users, :confirmation_token

    remove_column :users, :confirmation_sent_at
    remove_column :users, :confirmed_at
    remove_column :users, :confirmation_token
  end
end
