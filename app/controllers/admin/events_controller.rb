module Admin
  class EventsController < AdminController
    active_scaffold :event do |config|
      event_backend_columns = [ :name, :title, :description, :location, :url, :logo_url, :lug, :has_afols_event, :has_event_shirt, :has_accommodation, :has_moc_transport,  :has_moc_card_service, :has_tickets, :has_option_1, :label_option_1, :has_option_2, :label_option_2, :has_option_3, :label_option_3, :has_option_4, :label_option_4, :has_option_5, :label_option_5, :registration_open, :edit_of_attendees_allowed, :edit_of_exhibits_allowed, :visible, :start_date, :end_date, :additional_information ]
      config.list.columns = event_backend_columns
      config.create.columns = event_backend_columns
      config.update.columns = event_backend_columns
    end
  end
end
