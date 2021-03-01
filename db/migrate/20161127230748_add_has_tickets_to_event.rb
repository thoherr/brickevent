class AddHasTicketsToEvent < ActiveRecord::Migration[3.1]
  def change
    add_column :events, :has_afols_event, :boolean, :default => true
    add_column :events, :has_tickets, :boolean, :default => true
  end
end
