class ChangeBuildingHoursToString < ActiveRecord::Migration[4.2]
  def self.up
    change_table :exhibits do |t|
      t.change :building_hours, :string
    end
  end

  def self.down
    change_table :exhibits do |t|
      t.change :building_hours, :integer
    end
  end
end
