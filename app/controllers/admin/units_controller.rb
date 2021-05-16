module Admin
  class UnitsController < AdminController
    active_scaffold :unit do |config|
      list_columns = [ :name, :description, :centimeter ]
      config.list.columns = list_columns
      config.show.columns = list_columns
      config.update.columns = list_columns
      config.create.columns = list_columns
    end
  end
end
