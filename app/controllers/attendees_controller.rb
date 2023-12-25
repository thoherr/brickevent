# encoding: UTF-8
class AttendeesController < ApplicationController
  # GET /attendees/new
  # GET /attendees/new.json
  def new
    store_referrer
    @attendee = Attendee.new
    @attendee.attendance_id = params[:attendance_id] unless params[:attendance_id].nil?

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @attendee }
    end
  end

  def approve
    load_attendee
    raise 'approval denied' unless @attendee.event.is_managed_by?(current_user) || current_user.is_admin?
    if @attendee
      @attendee.is_approved=!@attendee.is_approved
      respond_to do |format|
        if @attendee.save
          format.html { redirect_to @attendee.event, :notice => t('attendee_confirmation_changed') }
          format.json { render :json => @attendee.event, :status => :updated, :location => @event }
        else
          format.html { render :action => "show" }
          format.json { render :json => @attendee.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # GET /attendees/1/edit
  def edit
    store_referrer
    load_attendee
  end

  # POST /attendees
  # POST /attendees.json
  def create
    @attendee = Attendee.new(attendee_params)

    respond_to do |format|
      if @attendee.save
        format.html { redirect_back_or_default @attendee.attendance, :notice => t('attendee_added') }
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
    load_attendee

    respond_to do |format|
      if @attendee.update(attendee_params)
        format.html { redirect_back_or_default @attendee.attendance, :notice => t('attendee_updated') }
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
    store_referrer
    load_attendee
    @attendance_id = @attendee.attendance_id
    @attendee.destroy

    respond_to do |format|
      format.html { redirect_back_or_default attendance_path(@attendance_id), :notice => t('attendee_deleted') }
      format.json { head :ok }
    end
  end

  private

  def load_attendee
    @attendee = Attendee.find(params[:id])
    raise 'Unauthorized request' unless authorized?(@attendee)
  end

  def attendee_params
    params.require(:attendee).permit(:attendance_id, :attendee_type_id, :name, :lug, :nickname, :email,
                                     :afols_event, :remarks, :shirt_size, :needs_ticket,
                                     :option_1, :option_2, :option_3, :option_4, :option_5,
                                     :number_of_shirts)
  end
end
