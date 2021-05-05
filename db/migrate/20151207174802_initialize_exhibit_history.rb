class InitializeExhibitHistory < ActiveRecord::Migration[4.2]
  def up
    Exhibit.order('created_at desc').each do |e|
      if e.former_exhibit.nil?
        Exhibit.where('name = ? and created_at < ?', e.name, e.created_at).each do |se|
          if e.attendance != se.attendance && e.attendance.user == se.attendance.user
            e.former_exhibit = se
            e.save
          end
        end
      end
    end
  end

  def down
  end
end
