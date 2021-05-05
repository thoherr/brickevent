class AddMoccardFlagToEvent < ActiveRecord::Migration[4.2]
  def up
    change_table(:events) do |t|
      t.boolean :has_moc_card_service
    end
  end
  def down
    remove_column :events, :has_moc_card_service
  end
end
