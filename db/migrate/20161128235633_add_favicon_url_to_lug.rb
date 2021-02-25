class AddFaviconUrlToLug < ActiveRecord::Migration[3.1]
  def change
    add_column :lugs, :favicon_url, :string
  end
end
