class AddCachedVotesToExhibits < ActiveRecord::Migration[7.2]
  def change
    change_table :exhibits do |t|
      t.integer :cached_scoped_public_votes_total, default: 0
      t.integer :cached_scoped_public_votes_score, default: 0
      t.integer :cached_scoped_public_votes_up, default: 0
      t.integer :cached_scoped_public_votes_down, default: 0
      t.integer :cached_weighted_public_score, default: 0
      t.integer :cached_weighted_public_total, default: 0
      t.float :cached_weighted_public_average, default: 0.0

      t.integer :cached_scoped_attendees_votes_total, default: 0
      t.integer :cached_scoped_attendees_votes_score, default: 0
      t.integer :cached_scoped_attendees_votes_up, default: 0
      t.integer :cached_scoped_attendees_votes_down, default: 0
      t.integer :cached_weighted_attendees_score, default: 0
      t.integer :cached_weighted_attendees_total, default: 0
      t.float :cached_weighted_attendees_average, default: 0.0

    end
    Exhibit.find_each { |p| p.update_cached_votes("public") }
    Exhibit.find_each { |p| p.update_cached_votes("attendees") }
  end
end
