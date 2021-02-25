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
    @event = Event.find(params[:id])
    if @event
      # According to RFC 4180 the MIME type for our csv data is text/csv
      send_data(@event.attendees_as_csv.encode(Encoding::ISO_8859_15), :type => "text/csv", :filename => params[:filename])
    else
      redirect_to events_url
    end
  end

  def exhibits_as_csv
    @event = Event.find(params[:id])
    if @event
      # According to RFC 4180 the MIME type for our csv data is text/csv
      send_data(@event.exhibits_as_csv.encode(Encoding::ISO_8859_15), :type => "text/csv", :filename => params[:filename])
    else
      redirect_to events_url
    end
  end
end
