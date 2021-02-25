class AddOptions4And5 < ActiveRecord::Migration[3.1]
  def change
    add_column :events, :has_option_4, :boolean
    add_column :events, :label_option_4, :string
    add_column :events, :has_option_5, :boolean
    add_column :events, :label_option_5, :string
    add_column :attendees, :option_4, :boolean, :default => false
    add_column :attendees, :option_5, :boolean, :default => false
  end
end
