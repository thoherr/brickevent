module Admin
  class EventsController < AdminController
    active_scaffold :event do |config|
      update_columns = [ :name, :title, :description, :location, :url, :logo_url, :lugname, :has_afols_event, :has_event_shirt, :has_accommodation, :has_moc_transport,  :has_moc_card_service, :has_tickets, :has_option_1, :label_option_1, :has_option_2, :label_option_2, :has_option_3, :label_option_3, :registration_open, :visible, :start_date, :end_date, :additional_information ]
      config.update.columns = update_columns
    end
  end
end
