class AddShopFieldsToEvents < ActiveRecord::Migration[8.1]
  def change
    add_column :events, :show_order_link, :boolean, default: false, null: false
    add_column :events, :shop_url, :string
  end
end
