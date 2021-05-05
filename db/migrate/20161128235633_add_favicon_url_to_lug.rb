class AddFaviconUrlToLug < ActiveRecord::Migration[4.2]
  def change
    add_column :lugs, :favicon_url, :string
  end
end
