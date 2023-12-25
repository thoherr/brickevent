module Admin 
  class UsersController < AdminController
    active_scaffold :user do |config|
      update_columns = [:email, :name, :lug, :nickname, :address, :phone, :is_admin, :accept_data_storage]
      config.update.columns = update_columns
    end
  end
end
