class CreateAccommodationTypes < ActiveRecord::Migration
  def change
    create_table :accommodation_types do |t|
      t.string :name
      t.string :description
      t.integer :size

      t.timestamps
    end
  end
end
