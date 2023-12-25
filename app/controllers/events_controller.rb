# -*- encoding: utf-8 -*-
class EventsController < ApplicationController

  skip_before_action :authenticate_user!, :only => :index

  # GET /events
  # GET /events.json
  def index
    @events = Event.where("lug_id = ? and (registration_open = ? or visible = ?)", @lug.id, true, true).load

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @event }
    end
  end

  def attendees_as_csv
    get_event_for_data_export
    if @event
      # According to RFC 4180 the MIME type for our csv data is text/csv
      send_data(@event.attendees_as_csv.encode(Encoding::ISO_8859_15), :type => "text/csv", :filename => params[:filename])
    else
      redirect_to events_url
    end
  end

  def exhibits_as_csv
    get_event_for_data_export
    if @event
      # According to RFC 4180 the MIME type for our csv data is text/csv
      send_data(@event.exhibits_as_csv.encode(Encoding::ISO_8859_15), :type => "text/csv", :filename => params[:filename])
    else
      redirect_to events_url
    end
  end

  private

  def authorized?(event)
    event.is_managed_by?(current_user) || current_user.is_admin?
  end

  def get_event_for_data_export
    @event = Event.find(params[:id])
    raise 'Unauthorized request' unless authorized?(@event)
  end

end
