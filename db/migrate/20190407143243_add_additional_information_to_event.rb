class AddAdditionalInformationToEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :additional_information, :text, :limit => 65384
  end
end
