# encoding: UTF-8
class AccommodationsController < ApplicationController

  # GET /accommodations/new
  # GET /accommodations/new.json
  def new
    @accommodation = Accommodation.new
    @accommodation.attendance_id = params[:attendance_id] unless params[:attendance_id].nil?

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @accommodation }
    end
  end

  # GET /accommodations/1/edit
  def edit
    load_accommodation
  end

  # POST /accommodations
  # POST /accommodations.json
  def create
    @accommodation = Accommodation.new(accommodation_params)

    respond_to do |format|
      if @accommodation.save
        format.html { redirect_back_or_default @accommodation.attendance, :notice => 'Der Hotelwunsch wurde aufgenommen.'}
        format.json { render :json => @accommodation, :status => :created, :location => @accommodation }
      else
        format.html { render :action => "new" }
        format.json { render :json => @accommodation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /accommodations/1
  # PUT /accommodations/1.json
  def update
    load_accommodation

    respond_to do |format|
      if @accommodation.update(accommodation_params)
        format.html { redirect_back_or_default @accommodation.attendance, :notice => 'Der Hotelwunsch wurde geändert.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @accommodation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /accommodations/1
  # DELETE /accommodations/1.json
  def destroy
    load_accommodation
    @attendance_id = @accommodation.attendance_id
    @accommodation.destroy

    respond_to do |format|
      format.html { redirect_back_or_default attendance_path(@attendance_id), :notice => 'Der Hotelwunsch wurde gelöscht.' }
      format.json { head :ok }
    end
  end

  private

  def load_accommodation
    @accommodation = Accommodation.find(params[:id])
    raise 'Unauthorized request' unless authorized?(@accommodation)
  end

  def accommodation_params
    params.require(:accommodation).permit(:attendance_id, :accommodation_type_id, :count, :remarks)
  end
end
