class CreateExhibits < ActiveRecord::Migration
  def self.up
    create_table :exhibits do |t|
      t.integer :participation_id
      t.string :name
      t.string :description
      t.string :url
      t.string :size_studs
      t.string :size
      t.integer :value
      t.boolean :needs_power_supply
      t.boolean :needs_transportation
      t.boolean :is_installation
      t.boolean :is_part_of_installation
      t.integer :installation_exhibit_id
      t.string :remarks

      t.timestamps
    end
  end

  def self.down
    drop_table :exhibits
  end
end
