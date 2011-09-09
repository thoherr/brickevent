class ChangeStringToText < ActiveRecord::Migration
  def up
    change_column :accommodations, :remarks, :text, :limit => 65384
    change_column :attendees, :remarks, :text, :limit => 65384
    change_column :events, :description, :text, :limit => 65384
    change_column :events, :remarks, :text, :limit => 65384
    change_column :exhibits, :description, :text, :limit => 65384
    change_column :exhibits, :remarks, :text, :limit => 65384
  end

  def down
    change_column :accommodations, :remarks, :string
    change_column :attendees, :remarks, :string
    change_column :events, :description, :string
    change_column :events, :remarks, :string
    change_column :exhibits, :description, :string
    change_column :exhibits, :remarks, :string
  end
end
