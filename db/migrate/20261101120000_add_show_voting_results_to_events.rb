class AddShowVotingResultsToEvents < ActiveRecord::Migration[8.1]
  def change
    add_column :events, :show_voting_results, :boolean, default: false, null: false
  end
end
