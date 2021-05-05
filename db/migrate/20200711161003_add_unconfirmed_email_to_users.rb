class AddUnconfirmedEmailToUsers < ActiveRecord::Migration[4.2]
  def change
    # needed by devise > 4.0 if (re-)confirmable
    add_column :users, :unconfirmed_email, :string
  end
end
