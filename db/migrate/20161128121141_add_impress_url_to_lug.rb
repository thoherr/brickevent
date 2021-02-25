class AddImpressUrlToLug < ActiveRecord::Migration[3.1]
  def change
    add_column :lugs, :impress_url, :string
  end
end
