module Admin 
  class EventManagersController < AdminController
    active_scaffold :event_manager do |config|
      list_columns = [:event, :user]
      show_columns = list_columns
      config.list.columns = list_columns
      config.show.columns = show_columns
    end
  end
end
