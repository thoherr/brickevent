# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_11_04_195936) do
  create_table "accommodation_types", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "description"
    t.string "name"
    t.integer "size"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "accommodations", force: :cascade do |t|
    t.integer "accommodation_type_id"
    t.integer "attendance_id"
    t.integer "count"
    t.datetime "created_at", precision: nil, null: false
    t.text "remarks", limit: 65384
    t.datetime "updated_at", precision: nil, null: false
    t.index ["accommodation_type_id"], name: "index_accommodations_on_accommodation_type_id"
    t.index ["attendance_id"], name: "index_accommodations_on_attendance_id"
  end

  create_table "attendances", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "event_id"
    t.boolean "is_approved"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id"
    t.index ["event_id"], name: "index_attendances_on_event_id"
    t.index ["user_id", "event_id"], name: "index_attendances_on_user_id_and_event_id", unique: true
  end

  create_table "attendee_types", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "description"
    t.boolean "is_visible"
    t.string "name"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_attendee_types_on_name"
  end

  create_table "attendees", force: :cascade do |t|
    t.boolean "afols_event"
    t.integer "attendance_id"
    t.integer "attendee_type_id"
    t.datetime "created_at", precision: nil, null: false
    t.string "email"
    t.boolean "is_approved"
    t.string "lug"
    t.string "name"
    t.boolean "needs_ticket", default: true
    t.string "nickname"
    t.integer "number_of_shirts"
    t.boolean "option_1", default: false
    t.boolean "option_2", default: false
    t.boolean "option_3", default: false
    t.boolean "option_4", default: false
    t.boolean "option_5", default: false
    t.text "remarks", limit: 65384
    t.string "shirt_size"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["attendance_id"], name: "index_attendees_on_attendance_id"
    t.index ["attendee_type_id"], name: "index_attendees_on_attendee_type_id"
    t.index ["is_approved"], name: "index_attendees_on_is_approved"
  end

  create_table "builders", force: :cascade do |t|
    t.integer "attendee_id"
    t.datetime "created_at", precision: nil, null: false
    t.integer "exhibit_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["attendee_id"], name: "index_builders_on_attendee_id"
    t.index ["exhibit_id"], name: "index_builders_on_exhibit_id"
  end

  create_table "event_managers", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "event_id"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id"
    t.index ["event_id"], name: "index_event_managers_on_event_id"
    t.index ["user_id"], name: "index_event_managers_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.text "additional_information", limit: 65384
    t.datetime "created_at", precision: nil, null: false
    t.string "current_voting_scope"
    t.text "description", limit: 65384
    t.boolean "edit_of_attendees_allowed", default: false
    t.boolean "edit_of_exhibits_allowed", default: false
    t.date "end_date"
    t.boolean "has_accommodation"
    t.boolean "has_afols_event", default: true
    t.boolean "has_event_shirt"
    t.boolean "has_moc_card_service"
    t.boolean "has_moc_transport"
    t.boolean "has_option_1"
    t.boolean "has_option_2"
    t.boolean "has_option_3"
    t.boolean "has_option_4"
    t.boolean "has_option_5"
    t.boolean "has_tickets", default: true
    t.string "label_option_1"
    t.string "label_option_2"
    t.string "label_option_3"
    t.string "label_option_4"
    t.string "label_option_5"
    t.string "location"
    t.string "logo_url"
    t.integer "lug_id"
    t.string "lugname"
    t.string "name"
    t.boolean "registration_open"
    t.text "remarks", limit: 65384
    t.date "start_date"
    t.string "title"
    t.datetime "updated_at", precision: nil, null: false
    t.string "url"
    t.boolean "visible"
    t.index ["lug_id", "registration_open", "visible"], name: "index_events_on_lug_and_registration_and_visibility"
    t.index ["lug_id"], name: "index_events_on_lug_id"
    t.index ["start_date"], name: "index_events_on_start_date"
  end

  create_table "exhibits", force: :cascade do |t|
    t.integer "attendance_id"
    t.integer "brick_count"
    t.string "building_hours"
    t.integer "cached_scoped_attendees_votes_down", default: 0
    t.integer "cached_scoped_attendees_votes_score", default: 0
    t.integer "cached_scoped_attendees_votes_total", default: 0
    t.integer "cached_scoped_attendees_votes_up", default: 0
    t.integer "cached_scoped_public_votes_down", default: 0
    t.integer "cached_scoped_public_votes_score", default: 0
    t.integer "cached_scoped_public_votes_total", default: 0
    t.integer "cached_scoped_public_votes_up", default: 0
    t.float "cached_weighted_attendees_average", default: 0.0
    t.integer "cached_weighted_attendees_score", default: 0
    t.integer "cached_weighted_attendees_total", default: 0
    t.float "cached_weighted_public_average", default: 0.0
    t.integer "cached_weighted_public_score", default: 0
    t.integer "cached_weighted_public_total", default: 0
    t.datetime "created_at", precision: nil, null: false
    t.text "description", limit: 65384
    t.integer "former_exhibit_id"
    t.integer "installation_exhibit_id"
    t.boolean "is_approved"
    t.boolean "is_collab", default: false
    t.boolean "is_installation"
    t.boolean "is_part_of_installation"
    t.string "name"
    t.boolean "needs_power_supply"
    t.boolean "needs_transportation"
    t.integer "platform"
    t.integer "position"
    t.text "remarks", limit: 65384
    t.string "size"
    t.string "size_studs"
    t.integer "size_x"
    t.decimal "size_x_centimeter", precision: 6, scale: 1
    t.decimal "size_x_meter", precision: 7, scale: 2
    t.integer "size_y"
    t.decimal "size_y_centimeter", precision: 6, scale: 1
    t.decimal "size_y_meter", precision: 7, scale: 2
    t.integer "size_z"
    t.decimal "size_z_centimeter", precision: 6, scale: 1
    t.decimal "size_z_meter", precision: 7, scale: 2
    t.integer "unit_id"
    t.datetime "updated_at", precision: nil, null: false
    t.string "url"
    t.integer "value"
    t.index ["attendance_id"], name: "index_exhibits_on_attendance_id"
    t.index ["former_exhibit_id"], name: "index_exhibits_on_former_exhibit_id"
    t.index ["installation_exhibit_id"], name: "index_exhibits_on_installation_exhibit_id"
    t.index ["is_approved"], name: "index_exhibits_on_is_approved"
    t.index ["is_collab"], name: "index_exhibits_on_is_collab"
    t.index ["is_installation"], name: "index_exhibits_on_is_installation"
    t.index ["is_part_of_installation"], name: "index_exhibits_on_is_part_of_installation"
    t.index ["unit_id"], name: "index_exhibits_on_unit_id"
  end

  create_table "lugs", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "description"
    t.string "favicon_url"
    t.string "impress_url"
    t.string "info_mail"
    t.string "logo_url"
    t.string "name"
    t.string "request_pattern"
    t.datetime "updated_at", precision: nil, null: false
    t.string "url"
  end

  create_table "units", force: :cascade do |t|
    t.decimal "centimeter", precision: 7, scale: 4
    t.datetime "created_at", precision: nil, null: false
    t.string "description"
    t.string "name"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "users", force: :cascade do |t|
    t.boolean "accept_data_storage"
    t.string "address"
    t.datetime "confirmation_sent_at", precision: nil
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "email"
    t.string "encrypted_password", limit: 128, default: "", null: false
    t.boolean "is_admin"
    t.datetime "last_sign_in_at", precision: nil
    t.string "last_sign_in_ip"
    t.string "lug"
    t.string "name"
    t.string "nickname"
    t.string "phone"
    t.datetime "remember_created_at", precision: nil
    t.datetime "reset_password_sent_at", precision: nil
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0
    t.string "unconfirmed_email"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "visitors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "session_id"
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_visitors_on_session_id", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "votable_id"
    t.string "votable_type"
    t.boolean "vote_flag"
    t.string "vote_scope"
    t.integer "vote_weight"
    t.integer "voter_id"
    t.string "voter_type"
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
    t.index ["votable_type", "votable_id"], name: "index_votes_on_votable"
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"
    t.index ["voter_type", "voter_id"], name: "index_votes_on_voter"
  end
end
