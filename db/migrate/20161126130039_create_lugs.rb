class CreateLugs < ActiveRecord::Migration
  def change
    create_table :lugs do |t|
      t.string :name
      t.string :description
      t.string :url
      t.string :logo_url
      t.string :info_mail
      t.string :request_pattern
      t.timestamps
    end
  end
end
