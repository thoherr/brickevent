class CreateEvents < ActiveRecord::Migration[4.2]
  def change
    create_table :events do |t|
      t.string :name
      t.string :title
      t.string :description
      t.string :location
      t.string :url
      t.string :lug
      t.boolean :registration_open
      t.date :start_date
      t.date :end_date
      t.string :remarks

      t.timestamps
    end
  end
end
