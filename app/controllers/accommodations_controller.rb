# encoding: UTF-8
class AccommodationsController < ApplicationController

  # GET /accommodations/new
  # GET /accommodations/new.json
  def new
    store_referrer
    @accommodation = Accommodation.new
    @accommodation.attendance_id = params[:attendance_id] unless params[:attendance_id].nil?

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @accommodation }
    end
  end

  # GET /accommodations/1/edit
  def edit
    store_referrer
    @accommodation = Accommodation.find(params[:id])
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
    @accommodation = Accommodation.find(params[:id])

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
    store_referrer
    @accommodation = Accommodation.find(params[:id])
    @attendance_id = @accommodation.attendance_id
    @accommodation.destroy

    respond_to do |format|
      format.html { redirect_back_or_default attendance_path(@attendance_id), :notice => 'Der Hotelwunsch wurde gelöscht.' }
      format.json { head :ok }
    end
  end

  private
  def accommodation_params
    # FIXME: This is just a temporary wild card to get the app running on Raila 4.0
    params.require(:accommodation).permit!
  end
end
