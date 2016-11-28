class AddImpressUrlToLug < ActiveRecord::Migration
  def change
    add_column :lugs, :impress_url, :string
  end
end
