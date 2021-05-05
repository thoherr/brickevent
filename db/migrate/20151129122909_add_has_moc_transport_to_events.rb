class AddHasMocTransportToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :has_moc_transport, :boolean
  end
end
