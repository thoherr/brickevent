# encoding: UTF-8
class ExhibitsController < ApplicationController

  # GET /exhibits/new
  # GET /exhibits/new.json
  def new
    @exhibit = Exhibit.new
    @exhibit.attendance_id = params[:attendance_id] unless params[:attendance_id].nil?

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @exhibit }
    end
  end

  # POST /exhibits/approve
  # POST /exhibits/approve.json
  def approve
    load_exhibit
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
    load_exhibit
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
    load_exhibit

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
    load_exhibit
    @attendance_id = @exhibit.attendance_id
    @exhibit.destroy

    respond_to do |format|
      format.html { redirect_to attendance_path(@attendance_id), :notice => t('moc_deleted') }
      format.json { head :ok }
    end
  end

  def voting_poster
    load_exhibit
    @voting_poster = VotingPosterCreation.call(@exhibit)
    send_data(@voting_poster, :type => 'application/pdf',
              :filename => "#{@exhibit.id}-#{@exhibit.platform_position}.pdf")
  end

  def position_import
    return redirect_to request.referer, notice: I18n.t('no_file_added') if params[:file].nil?
    return redirect_to request.referer, notice: I18n.t('only_csv_files_allowed') unless params[:file].content_type == 'text/csv'

    CsvPositionImport.call(params[:file])

    redirect_to request.referer, notice: 'Position data imported'
  end
  private

  def load_exhibit
    @exhibit = Exhibit.find(params[:id])
    raise 'Unauthorized request' unless authorized?(@exhibit)
  end

  def exhibit_params
    # FIXME: get rid of "old" size attributes (size_studs, size, size_x_meter?, size_x_centimeter?, ....)
    params.require(:exhibit).permit(:attendance_id, :name, :description, :url,
                                    :size_studs, :size, :value, :building_hours, :brick_count,
                                    :needs_power_supply, :needs_transportation, :is_installation,
                                    :is_part_of_installation, :installation_exhibit_id,
                                    :remarks, :size_x, :size_y, :size_z, :unit_id,
                                    :size_x_meter, :size_y_meter, :size_z_meter,
                                    :former_exhibit_id,
                                    :size_x_centimeter, :size_y_centimeter, :size_z_centimeter)
  end
end
