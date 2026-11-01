# frozen_string_literal: true

# Votes and rank of every votable exhibit of an event, per voting scope
# (public / AFOLs voting) and poll (collabs / single MOCs).
#
#   standings = VotingStandings.call(event)
#   standings.scopes                       # => ["public", "attendees"] (scopes with votes)
#   standings.for(exhibit, Vote.PUBLIC_VOTES) # => #<Standing votes: 12, rank: 5, of: 230>
#
# Ranks use competition ranking: exhibits with the same number of votes share
# a rank and the next rank is skipped (12, 12, 9 votes -> ranks 1, 1, 3).
class VotingStandings < ApplicationService

  Standing = Struct.new(:votes, :rank, :of, keyword_init: true)

  class Result
    attr_reader :scopes

    def initialize(scopes, standings)
      @scopes = scopes
      @standings = standings
    end

    # nil when the exhibit is not votable or the scope has no votes
    def for(exhibit, scope)
      @standings.dig(scope, exhibit.id)
    end

    def any?
      scopes.any?
    end
  end

  SCOPES = [Vote.PUBLIC_VOTES, Vote.ATTENDEES_VOTES].freeze

  def initialize(event)
    @event = event
  end

  def call
    exhibits = Exhibit.joins(:attendance).where(attendances: { event_id: @event.id })
                      .includes(:installation).select(&:votable?)
    polls = exhibits.partition(&:is_collab?)

    counts = Vote.where(votable_type: Exhibit.base_class.name, votable_id: exhibits.map(&:id), vote_scope: SCOPES)
                 .group(:vote_scope, :votable_id).count

    scopes = SCOPES.select { |scope| counts.any? { |(s, _), _| s == scope } }
    standings = scopes.to_h do |scope|
      [scope, polls.reject(&:empty?).map { |poll| rank_poll(poll, scope, counts) }.reduce({}, :merge)]
    end
    Result.new(scopes, standings)
  end

  private

  def rank_poll(poll, scope, counts)
    votes = poll.to_h { |e| [e.id, counts.fetch([scope, e.id], 0)] }
    sorted = votes.values.sort.reverse
    rank_of = {}
    sorted.each_with_index { |v, i| rank_of[v] ||= i + 1 }
    votes.transform_values { |v| Standing.new(votes: v, rank: rank_of[v], of: poll.size) }
  end

end
