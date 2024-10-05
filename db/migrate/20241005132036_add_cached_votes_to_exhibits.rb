class AddCachedVotesToExhibits < ActiveRecord::Migration[7.2]
  def change
    change_table :exhibits do |t|
      t.integer :cached_votes_total, default: 0
      t.integer :cached_votes_score, default: 0
      t.integer :cached_votes_up, default: 0
      t.integer :cached_votes_down, default: 0
      t.integer :cached_weighted_score, default: 0
      t.integer :cached_weighted_total, default: 0
      t.float :cached_weighted_average, default: 0.0
    end

    Exhibit.find_each(&:update_cached_votes)
  end
end
