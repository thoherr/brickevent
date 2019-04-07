class AddAdditionalInformationToEvent < ActiveRecord::Migration
  def change
    add_column :events, :additional_information, :text, :limit => 65384
  end
end
