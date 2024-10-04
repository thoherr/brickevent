# encoding: UTF-8
class VotesController < ApplicationController

  skip_before_action :authenticate_user!, except: [:index]

  # GET /events/:id/votes
  # GET /events/:id/votes.json
  def index
    load_event
    @votes = Vote.where(vote_scope: @event.id)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @votes }
    end
  end

  # GET /exhibits/:id/votes/new
  # GET /exhibits/:id/votes/new.json
  def new
    load_exhibit_and_event
    if @exhibit
      visitor = Visitor.load_or_create(session[:session_id])
      @voted_already = visitor.voted_for? @exhibit, {:vote_scope => @event.id}
    end
    @vote = Vote.new
    render :layout => 'voting'
  end

  # POST /exhibits/:exhibit_id/votes
  # POST /exhibits/:exhibit_id/votes.json
  def create
    load_exhibit_and_event
    if @exhibit
      visitor = Visitor.load_or_create(session[:session_id])
      if visitor
        @exhibit.liked_by visitor, vote_scope: @event.id
        respond_to do |format|
          if @exhibit.save
            format.html { redirect_to new_vote_path(@exhibit) }
            format.json { render :json => @exhibit.to_s, :status => :updated, :location => @event }
          else
            format.html { redirect_to new_vote_path(@exhibit) }
            format.json { render :json => @exhibit.errors, :status => :unprocessable_entity }
          end
        end
      end
    end
  end

private

  def load_event
    @event = Event.find(params[:id])
    raise 'Unauthorized request' unless authorized?(@event)
  end


  def load_exhibit_and_event
    @exhibit = Exhibit.find(params[:id])
    @event = @exhibit.attendance.event # no nil guard using &, missing event is a fatal error
  end

end
