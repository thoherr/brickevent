# -*- encoding: utf-8 -*-
class AttendancesController < ApplicationController
  # GET /attendances
  # GET /attendances.json
  def index
    @attendances = Attendance.where(:user_id => current_user.id).order('id desc')
    @past_attendances = @attendances.select { |att| !att.event.start_date.nil? and att.event.start_date <= Date.today }
    @future_attendances = @attendances.select { |att| att.event.start_date.nil? or att.event.start_date > Date.today }

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @attendances }
    end
  end

  # GET /attendances/1
  # GET /attendances/1.json
  def show
    load_attendance

    @qr_png = RQRCode::QRCode.new(attendance_url(@attendance)).as_png(size: 240, border_modules: 2)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @attendance }
    end
  end

  # GET /attendances/new
  # GET /attendances/new.json
  def new
    @attendance = Attendance.new
    @attendance.user_id = params[:user_id] unless params[:user_id].nil?
    @attendance.event_id = params[:event_id] unless params[:event_id].nil?

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @attendance }
    end
  end

  # POST /attendances
  # POST /attendances.json
  def create
    @attendance = Attendance.new(attendance_params)

    respond_to do |format|
      if @attendance.save
        format.html { redirect_to @attendance }
        format.json { render :json => @attendance, :status => :created, :location => @attendance }
      else
        format.html { render :action => "new" }
        format.json { render :json => @attendance.errors, :status => :unprocessable_entity }
      end
    end
  end

  def approve
    load_attendance
    if @attendance
      raise 'approval denied' unless @attendance.event.is_managed_by?(current_user) || current_user.is_admin?
      @attendance.is_approved=!@attendance.is_approved
      respond_to do |format|
        if @attendance.save
          format.html { redirect_to @attendance.event, :notice => 'Anmeldebestätigung geändert.' }
          format.json { render :json => @attendance.event, :status => :updated, :location => @event }
        else
          format.html { render :action => "show" }
          format.json { render :json => @attendance.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # POST /attendances/copy_exhibits/:other_attendance_id
  def copy_exhibits
    load_attendance
    @other_attendance = Attendance.find(params[:other_attendance_id])

    respond_to do |format|
      if @attendance.copy_exhibits! @other_attendance
        format.html { redirect_to attendances_url, :notice => 'Einträge wurden kopiert.' }
        format.json { head :ok }
      else
        format.html { render :action => "show" }
        format.json { render :json => @attendance.errors, :status => :unprocessable_entity }
      end
    end
  end

  # POST /attendances/add_former_exhibit/:former_exhibit_id
  def add_former_exhibit
    load_attendance
    # TODO
    @former_exhibit = Exhibit.find(params[:former_exhibit_id])
    respond_to do |format|
      if @attendance.add_former_exhibit! @former_exhibit
        format.html { redirect_to attendances_url, :notice => 'Eintrag wurde kopiert.' }
        format.json { head :ok }
      else
        format.html { render :action => "show" }
        format.json { render :json => @attendance.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /attendances/former_exhibits
  def former_exhibits
    load_attendance
    # TODO
    # @former_exhibits =
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @attendance }
    end
  end

  private

  def load_attendance
    @attendance = Attendance.find(params[:id])
    raise 'Unauthorized request' unless authorized?(@attendance)
  end

  def attendance_params
    params.require(:attendance).permit(:user_id, :event_id, :is_approved)
  end
end
