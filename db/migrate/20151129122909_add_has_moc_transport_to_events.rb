class AddHasMocTransportToEvents < ActiveRecord::Migration
  def change
    add_column :events, :has_moc_transport, :boolean
  end
end
