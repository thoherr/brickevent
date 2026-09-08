require 'securerandom'

# Adds the per-attendee voucher code used as pretix voucher and backfills it
# for all existing attendees. Format: "<attendee id>-<UUID>" in upper case
# (pretix stores voucher codes upper case and matches case-insensitively).
class AddVoucherCodeToAttendees < ActiveRecord::Migration[8.1]
  BATCH_SIZE = 500

  def up
    add_column :attendees, :voucher_code, :string
    add_column :attendees, :voucher_exported_at, :datetime
    add_index :attendees, :voucher_code, unique: true

    last_id = 0
    loop do
      ids = connection.select_values("SELECT id FROM attendees WHERE id > #{last_id.to_i} ORDER BY id LIMIT #{BATCH_SIZE}")
      break if ids.empty?

      ids.each do |id|
        code = "#{id.to_i}-#{SecureRandom.uuid.upcase}"
        connection.update("UPDATE attendees SET voucher_code = #{connection.quote(code)} WHERE id = #{id.to_i}")
        last_id = id.to_i
      end
    end
  end

  def down
    remove_index :attendees, :voucher_code
    remove_column :attendees, :voucher_exported_at
    remove_column :attendees, :voucher_code
  end
end
