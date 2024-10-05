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

    @installations_vote_count = @event.installations.sum(&:cached_votes_score)
    @installations = @event.installations.sort_by(&:cached_votes_score).reverse
    # TODO limit (10) as parameter
    @top_voted_installations = @installations.first(10)
    @max_installations_votes = @top_voted_installations.max_by(&:cached_votes_score).number_of_votes unless @top_voted_installations.empty?

    @single_exhibits_vote_count = @event.single_exhibits.sum(&:cached_votes_score)
    @single_exhibits = @event.single_exhibits.sort_by(&:cached_votes_score).reverse
    # TODO limit (10) as parameter
    @top_voted_single_exhibits = @single_exhibits.first(10)
    @max_single_exhibits_votes = @top_voted_single_exhibits.max_by(&:cached_votes_score).number_of_votes unless @top_voted_single_exhibits.empty?

    respond_to do |format|
      format.html # votes.html.erb
      format.json { render :json => @top_voted_single_exhibits }
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

  private

  def load_event
    @event = Event.find(params[:id])
    raise 'Unauthorized request' unless authorized?(@event)
  end

end
