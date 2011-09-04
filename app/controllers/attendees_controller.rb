class AttendeesController < ApplicationController
  # GET /attendees
  # GET /attendees.json
  def index
    @attendees = Attendee.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @attendees }
    end
  end

  # GET /attendees/1
  # GET /attendees/1.json
  def show
    @attendee = Attendee.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @attendee }
    end
  end

  # GET /attendees/new
  # GET /attendees/new.json
  def new
    @attendee = Attendee.new
    @attendee.attendance_id = params[:attendance_id] unless params[:attendance_id].nil?

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @attendee }
    end
  end

  # GET /attendees/1/edit
  def edit
    @attendee = Attendee.find(params[:id])
  end

  # POST /attendees
  # POST /attendees.json
  def create
    @attendee = Attendee.new(params[:attendee])

    respond_to do |format|
      if @attendee.save
        format.html { redirect_to @attendee.attendance, :notice => 'Neuer Teilnehmer wurde hinzugefügt.' }
        format.json { render :json => @attendee, :status => :created, :location => @attendee }
      else
        format.html { render :action => "new" }
        format.json { render :json => @attendee.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /attendees/1
  # PUT /attendees/1.json
  def update
    @attendee = Attendee.find(params[:id])

    respond_to do |format|
      if @attendee.update_attributes(params[:attendee])
        format.html { redirect_to @attendee.attendance, :notice => 'Die Teilnehmerdaten wurden geändert.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @attendee.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /attendees/1
  # DELETE /attendees/1.json
  def destroy
    @attendee = Attendee.find(params[:id])
    @attendance_id = @attendee.attendance_id
    @attendee.destroy

    respond_to do |format|
      format.html { redirect_to attendance_path(@attendance_id), :notice => 'Der Teilnehmer wurde gelöscht.' }
      format.json { head :ok }
    end
  end
end
