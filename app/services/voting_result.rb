# frozen_string_literal: true

class VotingResult < ApplicationService

  TOP_COUNT = 10

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
    exhibits = @collabs ? @event.votable_collabs : @event.votable_single_exhibits
    votes = Vote.where(votable_type: Exhibit.base_class.name,
                       votable_id: exhibits.map(&:id),
                       vote_scope: @vote_scope)

    votes_by_exhibit = votes.group(:votable_id).count
    votes_by_exhibit.default = 0

    top_voted = exhibits.sort_by { |e| votes_by_exhibit[e.id] }.reverse.first(TOP_COUNT)

    {
      max_votes: top_voted.empty? ? nil : votes_by_exhibit[top_voted.first.id],
      vote_count: votes_by_exhibit.values.sum,
      top_voted: top_voted,
      votes_by_exhibit: votes_by_exhibit,
      voters: voter_statistics(votes.group(:voter_type, :voter_id).count.values)
    }
  end

  # Statistics about how many votes each distinct voter (browser session) cast.
  def voter_statistics(votes_per_voter)
    return { count: 0 } if votes_per_voter.empty?

    sorted = votes_per_voter.sort
    count = sorted.size
    mid = count / 2
    {
      count: count,
      min: sorted.first,
      max: sorted.last,
      average: sorted.sum.fdiv(count),
      median: count.odd? ? sorted[mid] : (sorted[mid - 1] + sorted[mid]).fdiv(2)
    }
  end

end
