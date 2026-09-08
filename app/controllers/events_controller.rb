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
          format.json { render :json => @event.current_voting_scope, :status => :ok, :location => @event }
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
          format.json { render :json => @event.current_voting_scope, :status => :ok, :location => @event }
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

  # Voucher list (id, name, email, voucher code) for pretix "Create multiple vouchers"
  def vouchers_as_csv
    load_event
    only_new = params[:all] != '1'
    send_data(@event.vouchers_as_csv(only_new: only_new).encode(Encoding::ISO_8859_15),
              :type => "text/csv", :filename => "pretix-vouchers.#{@event}.csv")
  end

  # Import of attendee master data (same columns as the attendee export)
  def attendee_import
    load_event
    return redirect_to event_path(@event), notice: I18n.t('no_file_added') if params[:file].nil?
    return redirect_to event_path(@event), notice: I18n.t('only_csv_files_allowed') unless csv_upload?(params[:file])

    import = CsvAttendeeImport.call(@event, params[:file])
    redirect_to event_path(@event),
                notice: I18n.t('attendee_data_imported_stats_notice', ignored: import[:ignore_count], failed: import[:failure_count], imported: import[:success_count]),
                alert: import[:errors].size > 0 ? I18n.t('failed_attendee_ids', inspect: import[:errors].inspect) : nil
  end

  # Import of the pretix order export (positions sheet)
  def order_import
    load_event
    return redirect_to event_path(@event), notice: I18n.t('no_file_added') if params[:file].nil?
    return redirect_to event_path(@event), notice: I18n.t('only_csv_files_allowed') unless csv_upload?(params[:file])

    import = CsvOrderImport.call(@event, params[:file])
    redirect_to event_path(@event),
                notice: I18n.t('order_data_imported_stats_notice', ignored: import[:ignore_count], failed: import[:failure_count], imported: import[:success_count]),
                alert: import[:errors].size > 0 ? I18n.t('failed_order_rows', inspect: import[:errors].join('; ')) : nil
  end

  def csv_import
    load_event
    return redirect_to event_path(@event), notice: I18n.t('no_file_added') if params[:file].nil?
    return redirect_to event_path(@event), notice: I18n.t('only_csv_files_allowed') unless params[:file].content_type == 'text/csv'

    if @event
      import = CsvExhibitImport.call(@event, params[:file])
      redirect_to event_path(@event),
                  notice: I18n.t('moc_data_imported_stats_notice', import: import[:ignore_count], import2: import[:failure_count], import3: import[:success_count]),
                  alert: import[:errors].size > 0 ? I18n.t('failed_moc_ids', inspect: import[:errors].inspect) : nil
    else
      redirect_to events_url
    end
  end

  private

  CSV_CONTENT_TYPES = %w[text/csv application/vnd.ms-excel application/csv text/plain].freeze

  def csv_upload?(upload)
    CSV_CONTENT_TYPES.include?(upload.content_type) || File.extname(upload.original_filename.to_s).casecmp?('.csv')
  end

  def load_event
    @event = Event.includes(
      attendances: [:user, :exhibits],
      attendees: { attendance: :user },
      exhibits: { attendance: [:user, { event: { attendances: :user } }] },
      accommodations: :attendance
    ).find(params[:id])
    raise 'Unauthorized request' unless authorized?(@event)
  end

end
