class AddCurrentVotingScopeToEvent < ActiveRecord::Migration[7.2]
  def change
    change_table :events do |t|
      t.string :current_voting_scope
    end
  end
end
