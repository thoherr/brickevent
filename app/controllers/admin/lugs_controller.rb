module Admin
  class LugsController < AdminController
    active_scaffold :lug do |config|
      update_columns = [ :name, :description, :url, :logo_url, :request_pattern ]
      config.update.columns = update_columns
    end
  end
end
