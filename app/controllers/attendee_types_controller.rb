class AttendeeTypesController < ApplicationController
  # GET /attendee_types
  # GET /attendee_types.json
  def index
    @attendee_types = AttendeeType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @attendee_types }
    end
  end

  # GET /attendee_types/1
  # GET /attendee_types/1.json
  def show
    @attendee_type = AttendeeType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @attendee_type }
    end
  end

  # GET /attendee_types/new
  # GET /attendee_types/new.json
  def new
    @attendee_type = AttendeeType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @attendee_type }
    end
  end

  # GET /attendee_types/1/edit
  def edit
    @attendee_type = AttendeeType.find(params[:id])
  end

  # POST /attendee_types
  # POST /attendee_types.json
  def create
    @attendee_type = AttendeeType.new(params[:attendee_type])

    respond_to do |format|
      if @attendee_type.save
        format.html { redirect_to @attendee_type, :notice => 'Attendee type was successfully created.' }
        format.json { render :json => @attendee_type, :status => :created, :location => @attendee_type }
      else
        format.html { render :action => "new" }
        format.json { render :json => @attendee_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /attendee_types/1
  # PUT /attendee_types/1.json
  def update
    @attendee_type = AttendeeType.find(params[:id])

    respond_to do |format|
      if @attendee_type.update_attributes(params[:attendee_type])
        format.html { redirect_to @attendee_type, :notice => 'Attendee type was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @attendee_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /attendee_types/1
  # DELETE /attendee_types/1.json
  def destroy
    @attendee_type = AttendeeType.find(params[:id])
    @attendee_type.destroy

    respond_to do |format|
      format.html { redirect_to attendee_types_url }
      format.json { head :ok }
    end
  end
end
