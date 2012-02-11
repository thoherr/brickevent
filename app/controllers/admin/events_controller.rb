module Admin 
  class EventsController < AdminController
    active_scaffold :event do |config|
#      list_columns = [:user_type, :email, :firstname, :lastname, :title, :salutation, :street_1, :street_2, :zipcode, :city, :tel, :institution, :sign_in_count, :last_sign_in_at, :tnc, :pp ]
#      show_columns = list_columns
#      update_columns = [:user_type, :email, :firstname, :lastname, :title, :salutation, :street_1, :street_2, :zipcode, :city, :tel, :institution, :sign_in_count, :tnc, :pp]
      update_columns = [ :name, :title, :description, :location, :url, :lug, :registration_open, :start_date, :end_date ]
#      create_columns = update_columns

#     config.list.columns = list_columns
#      config.show.columns = show_columns
      config.update.columns = update_columns
#      config.create.columns = create_columns
    end
  end
end
