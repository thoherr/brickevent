class CreateUnits < ActiveRecord::Migration[4.2]
  def change
    create_table :units do |t|
      t.string :name
      t.string :description
      t.decimal :factor

      t.timestamps
    end
    cm = Unit.new({ :name => 'cm', :description => 'Zentimeter', :factor => 0.01 })
    cm.save
    m = Unit.new({ :name => 'm', :description => 'Meter', :factor => 1.00 })
    m.save
    studs = Unit.new({ :name => 'studs', :description => 'Noppen', :factor => 0.008 })
    studs.save
    plate16 = Unit.new({ :name => 'plate16', :description => '16er Platten', :factor => (16 * 0.008) })
    plate16.save
    plate32 = Unit.new({ :name => 'plate32', :description => '32er Platten', :factor => (32 * 0.008) })
    plate32.save
    plate48 = Unit.new({ :name => 'plate48', :description => '48er Platten', :factor => (48 * 0.008) })
    plate48.save
  end
end
