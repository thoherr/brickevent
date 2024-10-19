# -*- encoding: utf-8 -*-
class EventsController < ApplicationController

  skip_before_action :authenticate_user!, :only => :index

  # GET /events
  # GET /events.json
  def index
    @events = Event.where("lug_id = ? and (registration_open = ? or visible = ?)", @lug.id, true, true).load

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    load_event

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @event }
    end
  end

  # GET /events/:id/votes
  # GET /events/:id/votes.json
  def votes
    load_event
  end

  def open_voting
    load_event
    if @event
      @event.current_voting_scope=params[:voting_scope]
      respond_to do |format|
        if @event.save
          format.html { redirect_to votes_event_path(@event), :notice => t('voting_started') }
          format.json { render :json => @event.current_voting_scope, :status => :updated, :location => @event }
        else
          format.html { render :action => "votes" }
          format.json { render :json => @event.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  def close_voting
    load_event
    if @event
      @event.current_voting_scope=''
      respond_to do |format|
        if @event.save
          format.html { redirect_to votes_event_path(@event), :notice => t('voting_stopped') }
          format.json { render :json => @event.current_voting_scope, :status => :updated, :location => @event }
        else
          format.html { render :action => "votes" }
          format.json { render :json => @event.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  def voting_posters
    load_event

    zip_data = VotingPosterZipfileCreation.call(@event)
    send_data zip_data,
              :type => 'application/zip',
              :disposition => 'attachment',
              :filename => "voting-posters.#{@event}.zip"
  end

  def attendees_as_csv
    load_event
    if @event
      # According to RFC 4180 the MIME type for our csv data is text/csv
      send_data(@event.attendees_as_csv.encode(Encoding::ISO_8859_15), :type => "text/csv", :filename => params[:filename])
    else
      redirect_to events_url
    end
  end

  def exhibits_as_csv
    load_event
    if @event
      # According to RFC 4180 the MIME type for our csv data is text/csv
      send_data(@event.exhibits_as_csv.encode(Encoding::ISO_8859_15), :type => "text/csv", :filename => params[:filename])
    else
      redirect_to events_url
    end
  end

  def csv_import
    load_event
    return redirect_to event_path(@event), notice: I18n.t('no_file_added') if params[:file].nil?
    return redirect_to event_path(@event), notice: I18n.t('only_csv_files_allowed') unless params[:file].content_type == 'text/csv'

    if @event
      sanitized_file = ActiveStorage::Filename.new(params[:file].original_filename).sanitized
      import = CsvExhibitImport.call(@event, sanitized_file)
      redirect_to event_path(@event),
                  notice: I18n.t('moc_data_imported_stats_notice', import: import[:ignore_count], import2: import[:failure_count], import3: import[:success_count]),
                  alert: import[:errors].size > 0 ? I18n.t('failed_moc_ids', inspect: import[:errors].inspect) : nil
    else
      redirect_to events_url
    end
  end

  private

  def load_event
    @event = Event.find(params[:id])
    raise 'Unauthorized request' unless authorized?(@event)
  end

end
