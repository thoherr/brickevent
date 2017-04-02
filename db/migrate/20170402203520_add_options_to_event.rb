class AddOptionsToEvent < ActiveRecord::Migration
  def change
    add_column :events, :has_option_1, :boolean
    add_column :events, :label_option_1, :string
    add_column :events, :has_option_2, :boolean
    add_column :events, :label_option_2, :string
    add_column :events, :has_option_3, :boolean
    add_column :events, :label_option_3, :string
  end
end
