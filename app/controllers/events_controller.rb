class EventsController < ApplicationController

  skip_before_filter :authenticate_user!, :only => :index

  # GET /events
  # GET /events.json
  def index
    @events = Event.find(:all, :conditions => ["registration_open = ? or visible = ?", true, true])

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

  def export_attendees_csv
    @event = Event.find(params[:id])
    op = StringIO.new("", "w")
    @event.export_attendees_csv(op)
    csv_string = op.string
    csv_string.gsub!("\n","\r\n")
    # According to RFC 4180 the MIME type for our csv data is text/csv
    send_data(csv_string, :type => "text/csv", :filename => params[:filename])
  end

  def export_exhibits_csv
    @event = Event.find(params[:id])
    op = StringIO.new("", "w")
    @event.export_exhibits_csv(op)
    csv_string = op.string
    csv_string.gsub!("\n","\r\n")
    # According to RFC 4180 the MIME type for our csv data is text/csv
    send_data(csv_string, :type => "text/csv", :filename => params[:filename])
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, :notice => 'Event was successfully created.' }
        format.json { render :json => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.json { render :json => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, :notice => 'Event was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :ok }
    end
  end
end
