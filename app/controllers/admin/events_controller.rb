module Admin
  class EventsController < AdminController
    active_scaffold :event do |config|
      update_columns = [ :name, :title, :description, :location, :url, :logo_url, :lug, :has_event_shirt, :has_accommodation, :has_transport,  :has_moc_card_service, :registration_open, :visible, :start_date, :end_date ]
      config.update.columns = update_columns
    end
  end
end
