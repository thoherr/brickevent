class AddMoccardFlagToEvent < ActiveRecord::Migration
  def up
    change_table(:events) do |t|
      t.boolean :has_moc_card_service
    end
  end
  def down
    remove_column :events, :has_moc_card_service
  end
end
