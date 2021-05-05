class CreateExhibits < ActiveRecord::Migration[4.2]
  def change
    create_table :exhibits do |t|
      t.integer :attendance_id
      t.string :name
      t.string :description
      t.string :url
      t.string :size_studs
      t.string :size
      t.integer :value
      t.integer :building_hours
      t.integer :brick_count
      t.boolean :needs_power_supply
      t.boolean :needs_transportation
      t.boolean :is_installation
      t.boolean :is_part_of_installation
      t.integer :installation_exhibit_id
      t.string :remarks

      t.timestamps
    end
  end
end
