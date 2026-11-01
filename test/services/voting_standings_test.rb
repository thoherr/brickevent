require "test_helper"

class VotingStandingsTest < ActiveSupport::TestCase
  setup do
    @event = events(:three)
    @visitor_count = 0
  end

  def moc(name, **attrs)
    Exhibit.create!({ attendance: attendances(:one), name: name, unit: units(:one) }.merge(attrs))
  end

  def vote(exhibit, times, scope = Vote.PUBLIC_VOTES)
    times.times do
      @visitor_count += 1
      exhibit.liked_by Visitor.create!(session_id: "standings-#{@visitor_count}"), vote_scope: scope
    end
  end

  test "ranks single MOCs by votes with shared ranks for ties" do
    a, b, c = moc("A"), moc("B"), moc("C")
    vote(a, 3)
    vote(b, 5)
    vote(c, 3)

    standings = VotingStandings.call(@event)
    singles = @event.reload.votable_single_exhibits.size

    assert_equal [Vote.PUBLIC_VOTES], standings.scopes
    assert_equal 5, standings.for(b, Vote.PUBLIC_VOTES).votes
    assert_equal 1, standings.for(b, Vote.PUBLIC_VOTES).rank
    assert_equal [2, 2], [a, c].map { |e| standings.for(e, Vote.PUBLIC_VOTES).rank }
    assert_equal singles, standings.for(a, Vote.PUBLIC_VOTES).of
    zero = standings.for(exhibits(:one), Vote.PUBLIC_VOTES)
    assert_equal 0, zero.votes
    assert_equal 4, zero.rank, "rank after the tie is skipped"
  end

  test "collabs are ranked in their own poll and their parts are not votable" do
    single = moc("Single")
    collab = moc("Collab layout", is_installation: true, is_collab: true)
    part = moc("Collab part", is_part_of_installation: true, installation: collab)
    vote(single, 1)
    vote(collab, 2)

    standings = VotingStandings.call(@event)

    collab_standing = standings.for(collab, Vote.PUBLIC_VOTES)
    assert_equal 1, collab_standing.rank
    assert_equal 1, collab_standing.of, "the collab poll only contains collabs"
    assert_equal 1, standings.for(single, Vote.PUBLIC_VOTES).rank
    assert_nil standings.for(part, Vote.PUBLIC_VOTES)
  end

  test "voting scopes are ranked separately and only listed when they have votes" do
    a, b = moc("A"), moc("B")
    vote(a, 2, Vote.PUBLIC_VOTES)
    vote(b, 1, Vote.ATTENDEES_VOTES)

    standings = VotingStandings.call(@event)

    assert_equal [Vote.PUBLIC_VOTES, Vote.ATTENDEES_VOTES], standings.scopes
    assert_equal 1, standings.for(a, Vote.PUBLIC_VOTES).rank
    assert_equal 0, standings.for(a, Vote.ATTENDEES_VOTES).votes
    assert_equal 1, standings.for(b, Vote.ATTENDEES_VOTES).rank
  end

  test "votes for exhibits of other events are ignored" do
    other = Exhibit.create!(attendance: attendances(:four), name: "Elsewhere", unit: units(:one))
    vote(other, 4)

    standings = VotingStandings.call(@event)

    assert_not standings.any?
    assert_nil standings.for(exhibits(:one), Vote.PUBLIC_VOTES)
  end
end
