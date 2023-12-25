module Admin 
  class AttendancesController < AdminController
    active_scaffold :attendance do |config|
      list_columns = [:user, :event, :is_approved]
      show_columns = list_columns

     config.list.columns = list_columns
      config.show.columns = show_columns
    end
  end
end
