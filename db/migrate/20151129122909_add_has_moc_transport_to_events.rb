class AddHasMocTransportToEvents < ActiveRecord::Migration[3.1]
  def change
    add_column :events, :has_moc_transport, :boolean
  end
end
