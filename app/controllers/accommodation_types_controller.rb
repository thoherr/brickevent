class AccommodationTypesController < ApplicationController
  # GET /accommodation_types
  # GET /accommodation_types.json
  def index
    @accommodation_types = AccommodationType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @accommodation_types }
    end
  end

  # GET /accommodation_types/1
  # GET /accommodation_types/1.json
  def show
    @accommodation_type = AccommodationType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @accommodation_type }
    end
  end

  # GET /accommodation_types/new
  # GET /accommodation_types/new.json
  def new
    @accommodation_type = AccommodationType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @accommodation_type }
    end
  end

  # GET /accommodation_types/1/edit
  def edit
    @accommodation_type = AccommodationType.find(params[:id])
  end

  # POST /accommodation_types
  # POST /accommodation_types.json
  def create
    @accommodation_type = AccommodationType.new(params[:accommodation_type])

    respond_to do |format|
      if @accommodation_type.save
        format.html { redirect_to @accommodation_type, :notice => 'Accommodation type was successfully created.' }
        format.json { render :json => @accommodation_type, :status => :created, :location => @accommodation_type }
      else
        format.html { render :action => "new" }
        format.json { render :json => @accommodation_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /accommodation_types/1
  # PUT /accommodation_types/1.json
  def update
    @accommodation_type = AccommodationType.find(params[:id])

    respond_to do |format|
      if @accommodation_type.update_attributes(params[:accommodation_type])
        format.html { redirect_to @accommodation_type, :notice => 'Accommodation type was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @accommodation_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /accommodation_types/1
  # DELETE /accommodation_types/1.json
  def destroy
    @accommodation_type = AccommodationType.find(params[:id])
    @accommodation_type.destroy

    respond_to do |format|
      format.html { redirect_to accommodation_types_url }
      format.json { head :ok }
    end
  end
end
