class AddFaviconUrlToLug < ActiveRecord::Migration
  def change
    add_column :lugs, :favicon_url, :string
  end
end
