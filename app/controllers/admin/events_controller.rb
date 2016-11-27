module Admin
  class EventsController < AdminController
    active_scaffold :event do |config|
      update_columns = [ :name, :title, :description, :location, :url, :logo_url, :lugname, :has_afols_event, :has_event_shirt, :has_accommodation, :has_moc_transport,  :has_moc_card_service, :has_tickets, :registration_open, :visible, :start_date, :end_date ]
      config.update.columns = update_columns
    end
  end
end
