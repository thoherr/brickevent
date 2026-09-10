# Boolean flags were nullable, so the admin backend rendered them as
# true/false/blank dropdowns and NULL had to be treated as false everywhere.
# Give every flag a default and NOT NULL (existing NULLs become the value in
# NULL_REPLACEMENT, or the default) so they behave, and render, as checkboxes.
#
# Not touched: votes.vote_flag (table owned by acts_as_votable; a NULL there
# would have to become an up- or downvote).
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
    },
    attendances: {
      is_approved: false
    },
    exhibits: {
      is_approved: false,
      is_collab: false,
      is_installation: false,
      is_part_of_installation: false,
      needs_power_supply: false,
      needs_transportation: false
    },
    # new attendee types should be visible by default, but types that are NULL
    # today are hidden in the registration form (where(is_visible: true)) and
    # must stay hidden, see NULL_REPLACEMENT
    attendee_types: {
      is_visible: true
    },
    users: {
      accept_data_storage: false,
      is_admin: false
    }
  }.freeze

  NULL_REPLACEMENT = {
    attendee_types: { is_visible: false }
  }.freeze

  def up
    FLAGS.each do |table, columns|
      columns.each do |column, default|
        replacement = NULL_REPLACEMENT.dig(table, column)
        replacement = default if replacement.nil?
        change_column_default table, column, default
        change_column_null table, column, false, replacement
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
