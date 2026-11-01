# encoding: UTF-8
class ExhibitsController < ApplicationController

  # GET /exhibits/new
  # GET /exhibits/new.json
  def new
    @exhibit = Exhibit.new
    @exhibit.attendance_id = params[:attendance_id] unless params[:attendance_id].nil?
    authorize!(@exhibit) if @exhibit.attendance_id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @exhibit }
    end
  end

  # POST /exhibits/approve
  # POST /exhibits/approve.json
  def approve
    load_exhibit
    authorize_event_manager!(@exhibit.event)
    @exhibit.is_approved=!@exhibit.is_approved
    respond_to do |format|
      if @exhibit.save
        format.html { redirect_to @exhibit.attendance.event, :notice => t('moc_confirmation_changed') }
        format.json { render :json => @exhibit.attendance.event, :status => :ok, :location => @event }
      else
        format.html { render :action => "show" }
        format.json { render :json => @exhibit.errors, :status => :unprocessable_entity }
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
    authorize!(@exhibit)

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
    @exhibit.assign_attributes(exhibit_params)
    authorize!(@exhibit) # also when the MOC is moved to another registration

    respond_to do |format|
      if @exhibit.save
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
    @poster = VotingPosterCreation.call(@exhibit)
    send_data(@poster[:pdf], :type => 'application/pdf',
              :filename => @poster[:filename])
  end

  private

  def load_exhibit
    @exhibit = Exhibit.find(params[:id])
    authorize!(@exhibit)
  end

  # Fields only event managers and admins may set (the form hides them from attendees).
  MANAGER_FIELDS = %i[platform position is_installation is_collab].freeze

  def exhibit_params
    # FIXME: get rid of "old" size attributes (size_studs, size, size_x_meter?, size_x_centimeter?, ....)
    permitted = %i[attendance_id name description url
                   size_studs size value building_hours brick_count
                   needs_power_supply needs_transportation
                   is_part_of_installation installation_exhibit_id
                   remarks size_x size_y size_z unit_id
                   size_x_meter size_y_meter size_z_meter
                   former_exhibit_id
                   size_x_centimeter size_y_centimeter size_z_centimeter]
    permitted += MANAGER_FIELDS if event_manager?(exhibit_event)
    params.require(:exhibit).permit(*permitted)
  end

  # The event the submitted MOC belongs to: that of the target registration
  # for new MOCs, otherwise that of the existing MOC.
  def exhibit_event
    attendance_id = params.dig(:exhibit, :attendance_id)
    return Attendance.find_by(id: attendance_id)&.event if attendance_id.present?

    @exhibit&.event
  end
end
