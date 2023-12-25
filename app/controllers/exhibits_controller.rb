# encoding: UTF-8
class ExhibitsController < ApplicationController
  # GET /exhibits/new
  # GET /exhibits/new.json
  def new
    store_referrer
    @exhibit = Exhibit.new
    @exhibit.attendance_id = params[:attendance_id] unless params[:attendance_id].nil?

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @exhibit }
    end
  end

  def approve
    get_exhibit
    if @exhibit
      raise 'approval denied' unless @exhibit.attendance.event.is_managed_by?(current_user) || current_user.is_admin?
      @exhibit.is_approved=!@exhibit.is_approved
      respond_to do |format|
        if @exhibit.save
          format.html { redirect_to @exhibit.attendance.event, :notice => t('moc_confirmation_changed') }
          format.json { render :json => @exhibit.attendance.event, :status => :updated, :location => @event }
        else
          format.html { render :action => "show" }
          format.json { render :json => @exhibit.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # GET /exhibits/1/edit
  def edit
    store_referrer
    get_exhibit
  end

  # POST /exhibits
  # POST /exhibits.json
  def create
    @exhibit = Exhibit.new(exhibit_params)

    respond_to do |format|
      if @exhibit.save
        format.html { redirect_back_or_default @exhibit.attendance, :notice => t('moc_created') }
        format.json { render :json => @exhibit, :status => :created, :location => @exhibit }
      else
        format.html { render :action => "new" }
        format.json { render :json => @exhibit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /exhibits/1
  # PUT /exhibits/1.json
  def update
    get_exhibit

    respond_to do |format|
      if @exhibit.update(exhibit_params)
        format.html { redirect_back_or_default @exhibit.attendance, :notice => t('moc_updated') }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @exhibit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /exhibits/1
  # DELETE /exhibits/1.json
  def destroy
    get_exhibit
    @attendance_id = @exhibit.attendance_id
    @exhibit.destroy

    respond_to do |format|
      format.html { redirect_to attendance_path(@attendance_id), :notice => t('moc_deleted') }
      format.json { head :ok }
    end
  end

  private

  def get_exhibit
    @exhibit = Exhibit.find(params[:id])
    raise 'Unauthorized request' unless authorized?(@exhibit)
  end

  def authorized?(exhibit)
    exhibit.owner == current_user ||
      exhibit.attendance.event.is_managed_by?(current_user) ||
      current_user.is_admin?
  end

  def exhibit_params
    # FIXME: This is just a temporary wild card to get the app running on Raila 4.0
    params.require(:exhibit).permit!
  end
end
