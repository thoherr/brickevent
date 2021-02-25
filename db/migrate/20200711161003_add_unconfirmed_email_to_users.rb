class AddUnconfirmedEmailToUsers < ActiveRecord::Migration
  def change
    # needed by devise > 4.0 if (re-)confirmable
    add_column :users, :unconfirmed_email, :string
  end
end
