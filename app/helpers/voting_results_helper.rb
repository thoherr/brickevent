# frozen_string_literal: true

# Voting results in the MOC tables of the event and attendance pages.
module VotingResultsHelper

  # Standings of all votable exhibits of the event, computed once per request.
  def voting_standings(event)
    @voting_standings ||= {}
    @voting_standings[event.id] ||= VotingStandings.call(event)
  end

  # Admins and event managers always see the results, attendees only once the
  # event publishes them. Nothing is shown before any votes were cast.
  def show_voting_results?(event)
    return false if event.nil?
    return false unless event.show_voting_results? || user_is_admin? || event.is_managed_by?(current_user)

    voting_standings(event).any?
  end
end
