# encoding: UTF-8
class VotesController < ApplicationController

  skip_before_action :authenticate_user!

  # GET /exhibits/:id/votes/new
  # GET /exhibits/:id/votes/new.json
  def new
    load_exhibit
    if @exhibit
      visitor = Visitor.load_or_create(session[:session_id])
      @voted_already = visitor.voted_for? @exhibit
    end
    @vote = Vote.new
    render :layout => 'voting'
  end

  # POST /exhibits/:exhibit_id/votes
  # POST /exhibits/:exhibit_id/votes.json
  def create
    load_exhibit
    if @exhibit
      visitor = Visitor.load_or_create(session[:session_id])
      if visitor
        @exhibit.liked_by visitor
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

  def load_exhibit
    @exhibit = Exhibit.find(params[:id])
  end

end
