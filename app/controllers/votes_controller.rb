# encoding: UTF-8
class VotesController < ApplicationController

  skip_before_action :authenticate_user!

  # see https://stackoverflow.com/questions/30402183/prevent-user-going-back-and-viewing-previously-submitted-form-rails
  # disable duplicate voting form
  before_action :set_cache_buster

  # GET /exhibits/:id/votes/new
  # GET /exhibits/:id/votes/new.json
  def new
    load_visitor_exhibit_and_event
    @voted_already = @visitor.voted_for? @exhibit, vote_scope: @exhibit.current_voting_scope
    @vote = Vote.new
    render :layout => 'voting'
  end

  # POST /exhibits/:exhibit_id/votes
  # POST /exhibits/:exhibit_id/votes.json
  def create
    load_visitor_exhibit_and_event
    @voted_already = @visitor.voted_for? @exhibit, vote_scope: @exhibit.current_voting_scope
    if @voted_already
      redirect_to new_vote_path(@exhibit, :notice => t('cannot_vote_twice'))
    else
      @exhibit.liked_by @visitor, vote_scope: @exhibit.current_voting_scope
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

  private

  def load_visitor_exhibit_and_event
    begin
      @visitor = Visitor.load_or_create(session[:session_id])
      @exhibit = Exhibit.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      raise 'INVALID REQUEST'
    else
      @event = @exhibit.attendance.event
      raise 'INVALID REQUEST' unless @exhibit and @visitor and @event
    end
  end

  protected

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "#{1.year.ago}"
  end

end