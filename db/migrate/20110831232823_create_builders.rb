class CreateBuilders < ActiveRecord::Migration[3.1]
  def change
    create_table :builders do |t|
      t.integer :exhibit_id
      t.integer :attendee_id

      t.timestamps
    end
  end
end
