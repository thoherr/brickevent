class AddHasTicketsToEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :has_afols_event, :boolean, :default => true
    add_column :events, :has_tickets, :boolean, :default => true
  end
end
