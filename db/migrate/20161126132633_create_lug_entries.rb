class CreateLugEntries < ActiveRecord::Migration
  def up
    Event.find_each do |ev|
      lug = Lug.find_by_name(ev.lugname)
      if lug.nil?
        lug = Lug.new({ :name => ev.lugname })
        lug.save
      end
      ev.lug = lug
      ev.save
    end
  end
end
