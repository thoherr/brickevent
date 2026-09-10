# Boolean flags on events and attendees were nullable, so the admin backend
# rendered them as true/false/blank dropdowns and NULL had to be treated as
# false everywhere. Give every flag a default and NOT NULL (existing NULLs
# become the default) so they behave, and render, as plain checkboxes.
class MakeBooleanFlagsNotNull < ActiveRecord::Migration[8.1]
  FLAGS = {
    events: {
      edit_of_attendees_allowed: false,
      edit_of_exhibits_allowed: false,
      has_accommodation: false,
      has_afols_event: true,
      has_event_shirt: false,
      has_moc_card_service: false,
      has_moc_transport: false,
      has_option_1: false,
      has_option_2: false,
      has_option_3: false,
      has_option_4: false,
      has_option_5: false,
      has_tickets: true,
      registration_open: false,
      visible: false
    },
    attendees: {
      afols_event: false,
      is_approved: false,
      needs_ticket: true,
      option_1: false,
      option_2: false,
      option_3: false,
      option_4: false,
      option_5: false
    }
  }.freeze

  def up
    FLAGS.each do |table, columns|
      columns.each do |column, default|
        change_column_default table, column, default
        change_column_null table, column, false, default
      end
    end
  end

  def down
    FLAGS.each do |table, columns|
      columns.each_key do |column|
        change_column_null table, column, true
      end
    end
  end
end
