class ChangeBuildingHoursToString < ActiveRecord::Migration[3.1]
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
