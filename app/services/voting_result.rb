# frozen_string_literal: true

class VotingResult < ApplicationService

  def initialize(event, vote_scope, collabs)
    @event = event
    @vote_scope = vote_scope
    @collabs = collabs
  end

  def call
    voting_result
  end

  private

  def voting_result

    @exhibits = if @collabs
                  @event.votable_collabs
                else
                  @event.votable_single_exhibits
                end

    @exhibits = @exhibits.sort_by{|e| e.find_votes_for(vote_scope: @vote_scope).size}.reverse
    @vote_count = @exhibits.sum{|e| e.find_votes_for(vote_scope: @vote_scope).size}
    # TODO limit (10) as parameter
    @top_voted = @exhibits.first(10)
    @max_votes = @top_voted.max_by{|e| e.find_votes_for(vote_scope: @vote_scope).size}.find_votes_for(vote_scope: @vote_scope).size unless @top_voted.empty?
    { :max_votes => @max_votes, :vote_count => @vote_count, :top_voted => @top_voted }
  end

end
