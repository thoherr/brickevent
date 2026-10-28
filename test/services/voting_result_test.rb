require "test_helper"

class VotingResultTest < ActiveSupport::TestCase
  def setup
    @event = events(:one)
    @exhibit_one = exhibits(:one)
    @exhibit_two = exhibits(:two)
  end

  test "returns voting result structure with max_votes, vote_count, and top_voted" do
    result = VotingResult.call(@event, Vote.PUBLIC_VOTES, false)

    assert_not_nil result
    assert result.key?(:max_votes)
    assert result.key?(:vote_count)
    assert result.key?(:top_voted)
  end

  test "returns empty result when no votable exhibits exist" do
    # Use an event with no exhibits
    event_without_exhibits = Event.create!(
      name: "Test Event",
      title: "Test",
      start_date: Date.today,
      end_date: Date.today + 1.day,
      lug: lugs(:lugone)
    )

    result = VotingResult.call(event_without_exhibits, Vote.PUBLIC_VOTES, false)

    assert_equal 0, result[:vote_count]
    assert_equal [], result[:top_voted]
    assert_nil result[:max_votes]
  end

  test "filters single exhibits when collabs is false" do
    result = VotingResult.call(@event, Vote.PUBLIC_VOTES, false)

    assert_not_nil result[:top_voted], "Should return top_voted array"
    # Should only include non-collab single exhibits
    result[:top_voted].each do |exhibit|
      assert exhibit.votable?, "Exhibit should be votable"
      assert_not exhibit.is_collab?, "Should not include collabs when collabs=false"
    end
  end

  test "filters collab exhibits when collabs is true" do
    # Create a collab exhibit for testing
    collab_exhibit = Exhibit.create!(
      attendance: attendances(:one),
      name: "Collab MOC",
      is_collab: true,
      unit: units(:one)
    )

    result = VotingResult.call(@event, Vote.PUBLIC_VOTES, true)

    assert_not_nil result[:top_voted], "Should return top_voted array"
    # Should only include collabs
    result[:top_voted].each do |exhibit|
      assert exhibit.votable?, "Exhibit should be votable"
    end
  end

  test "limits results to top 10 exhibits" do
    # This tests the limit functionality even though we may not have 10 exhibits
    result = VotingResult.call(@event, Vote.PUBLIC_VOTES, false)

    assert result[:top_voted].size <= 10, "Should return at most 10 exhibits"
  end

  test "respects vote_scope parameter" do
    # Test with different vote scopes
    public_result = VotingResult.call(@event, Vote.PUBLIC_VOTES, false)
    attendees_result = VotingResult.call(@event, Vote.ATTENDEES_VOTES, false)

    # Both should return valid results (may be same if no votes exist)
    assert_not_nil public_result[:top_voted]
    assert_not_nil attendees_result[:top_voted]
  end

  test "calculates vote_count as sum of all votes" do
    result = VotingResult.call(@event, Vote.PUBLIC_VOTES, false)

    # vote_count should be non-negative
    assert result[:vote_count] >= 0

    # If there are top_voted exhibits, vote_count should match
    if result[:top_voted].any?
      calculated_count = result[:top_voted].sum do |exhibit|
        exhibit.find_votes_for(vote_scope: Vote.PUBLIC_VOTES).size
      end
      # vote_count includes all exhibits, top_voted is limited to 10
      assert result[:vote_count] >= calculated_count
    end
  end

  # Casts votes for the given [visitor index, exhibit] pairs.
  def cast_votes(pairs, scope = Vote.PUBLIC_VOTES)
    visitors = Hash.new { |h, i| h[i] = Visitor.load_or_create("voting-result-test-#{i}") }
    pairs.each { |vi, exhibit| exhibit.liked_by visitors[vi], vote_scope: scope }
  end

  def votable_exhibits(event, count)
    existing = event.votable_single_exhibits
    (existing.size...count).each do |i|
      Exhibit.create!(attendance: attendances(:one), name: "Voting test MOC #{i}", unit: units(:one))
    end
    event.reload.votable_single_exhibits.first(count)
  end

  test "counts votes per exhibit and orders top voted by votes" do
    event = events(:three)
    a, b, c = votable_exhibits(event, 3)
    cast_votes([[0, a], [0, b], [0, c], [1, a], [1, b], [2, c], [3, a]])

    result = VotingResult.call(event, Vote.PUBLIC_VOTES, false)

    assert_equal 7, result[:vote_count]
    assert_equal 3, result[:max_votes]
    assert_equal a, result[:top_voted].first
    assert_equal({ a.id => 3, b.id => 2, c.id => 2 }, result[:votes_by_exhibit].slice(a.id, b.id, c.id))
    assert_equal 0, result[:votes_by_exhibit][-1], "unvoted exhibits count as zero"
  end

  test "computes distinct voters and votes per voter statistics" do
    event = events(:three)
    a, b, c = votable_exhibits(event, 3)
    # votes per voter: 3, 2, 1, 1
    cast_votes([[0, a], [0, b], [0, c], [1, a], [1, b], [2, c], [3, a]])

    voters = VotingResult.call(event, Vote.PUBLIC_VOTES, false)[:voters]

    assert_equal 4, voters[:count]
    assert_equal 1, voters[:min]
    assert_equal 3, voters[:max]
    assert_in_delta 1.75, voters[:average]
    assert_equal 1.5, voters[:median]
  end

  test "median of an odd number of voters is the middle value" do
    event = events(:three)
    a, b, c = votable_exhibits(event, 3)
    # votes per voter: 3, 1, 1
    cast_votes([[0, a], [0, b], [0, c], [1, a], [2, b]])

    voters = VotingResult.call(event, Vote.PUBLIC_VOTES, false)[:voters]

    assert_equal 3, voters[:count]
    assert_equal 1, voters[:median]
  end

  test "votes of other scopes and other events are not counted" do
    event = events(:three)
    a, = votable_exhibits(event, 1)
    other_exhibit = Exhibit.create!(attendance: attendances(:four), name: "Other event MOC", unit: units(:one))
    cast_votes([[0, a]])
    cast_votes([[0, a], [1, a]], Vote.ATTENDEES_VOTES)
    cast_votes([[5, other_exhibit]])

    result = VotingResult.call(event, Vote.PUBLIC_VOTES, false)

    assert_equal 1, result[:vote_count]
    assert_equal 1, result[:voters][:count]
  end

  test "voter statistics are empty without votes" do
    result = VotingResult.call(events(:three), Vote.PUBLIC_VOTES, false)

    assert_equal 0, result[:vote_count]
    assert_equal({ count: 0 }, result[:voters])
  end
end
