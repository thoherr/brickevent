class AddAdditionalInformationToEvent < ActiveRecord::Migration[3.1]
  def change
    add_column :events, :additional_information, :text, :limit => 65384
  end
end
