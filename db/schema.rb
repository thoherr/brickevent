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

ActiveRecord::Schema[7.2].define(version: 2024_10_06_160928) do
  create_table "accommodation_types", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "size"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "accommodations", force: :cascade do |t|
    t.integer "attendance_id"
    t.integer "accommodation_type_id"
    t.integer "count"
    t.text "remarks", limit: 65384
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "attendances", force: :cascade do |t|
    t.integer "user_id"
    t.integer "event_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "is_approved"
    t.index ["user_id", "event_id"], name: "index_attendances_on_user_id_and_event_id", unique: true
  end

  create_table "attendee_types", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "is_visible"
  end

  create_table "attendees", force: :cascade do |t|
    t.integer "attendance_id"
    t.integer "attendee_type_id"
    t.string "name"
    t.string "lug"
    t.string "nickname"
    t.string "email"
    t.boolean "afols_event"
    t.text "remarks", limit: 65384
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "shirt_size"
    t.boolean "is_approved"
    t.boolean "needs_ticket", default: true
    t.boolean "option_1", default: false
    t.boolean "option_2", default: false
    t.boolean "option_3", default: false
    t.boolean "option_4", default: false
    t.boolean "option_5", default: false
    t.integer "number_of_shirts"
  end

  create_table "builders", force: :cascade do |t|
    t.integer "exhibit_id"
    t.integer "attendee_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "event_managers", force: :cascade do |t|
    t.integer "event_id"
    t.integer "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.text "description", limit: 65384
    t.string "location"
    t.string "url"
    t.string "lugname"
    t.boolean "registration_open"
    t.date "start_date"
    t.date "end_date"
    t.text "remarks", limit: 65384
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "has_event_shirt"
    t.boolean "has_accommodation"
    t.boolean "has_moc_card_service"
    t.string "logo_url"
    t.boolean "visible"
    t.boolean "has_moc_transport"
    t.integer "lug_id"
    t.boolean "has_afols_event", default: true
    t.boolean "has_tickets", default: true
    t.boolean "has_option_1"
    t.string "label_option_1"
    t.boolean "has_option_2"
    t.string "label_option_2"
    t.boolean "has_option_3"
    t.string "label_option_3"
    t.text "additional_information", limit: 65384
    t.boolean "has_option_4"
    t.string "label_option_4"
    t.boolean "has_option_5"
    t.string "label_option_5"
    t.boolean "edit_of_attendees_allowed", default: false
    t.boolean "edit_of_exhibits_allowed", default: false
    t.string "current_voting_scope"
  end

  create_table "exhibits", force: :cascade do |t|
    t.integer "attendance_id"
    t.string "name"
    t.text "description", limit: 65384
    t.string "url"
    t.string "size_studs"
    t.string "size"
    t.integer "value"
    t.string "building_hours"
    t.integer "brick_count"
    t.boolean "needs_power_supply"
    t.boolean "needs_transportation"
    t.boolean "is_installation"
    t.boolean "is_part_of_installation"
    t.integer "installation_exhibit_id"
    t.text "remarks", limit: 65384
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "size_x"
    t.integer "size_y"
    t.integer "size_z"
    t.integer "unit_id"
    t.decimal "size_x_meter", precision: 7, scale: 2
    t.decimal "size_y_meter", precision: 7, scale: 2
    t.decimal "size_z_meter", precision: 7, scale: 2
    t.integer "former_exhibit_id"
    t.boolean "is_approved"
    t.decimal "size_x_centimeter", precision: 6, scale: 1
    t.decimal "size_y_centimeter", precision: 6, scale: 1
    t.decimal "size_z_centimeter", precision: 6, scale: 1
    t.integer "platform"
    t.integer "position"
    t.integer "cached_scoped_public_votes_total", default: 0
    t.integer "cached_scoped_public_votes_score", default: 0
    t.integer "cached_scoped_public_votes_up", default: 0
    t.integer "cached_scoped_public_votes_down", default: 0
    t.integer "cached_weighted_public_score", default: 0
    t.integer "cached_weighted_public_total", default: 0
    t.float "cached_weighted_public_average", default: 0.0
    t.integer "cached_scoped_attendees_votes_total", default: 0
    t.integer "cached_scoped_attendees_votes_score", default: 0
    t.integer "cached_scoped_attendees_votes_up", default: 0
    t.integer "cached_scoped_attendees_votes_down", default: 0
    t.integer "cached_weighted_attendees_score", default: 0
    t.integer "cached_weighted_attendees_total", default: 0
    t.float "cached_weighted_attendees_average", default: 0.0
  end

  create_table "lugs", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "url"
    t.string "logo_url"
    t.string "info_mail"
    t.string "request_pattern"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "impress_url"
    t.string "favicon_url"
  end

  create_table "units", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.decimal "centimeter", precision: 7, scale: 4
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "encrypted_password", limit: 128, default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "name"
    t.string "lug"
    t.string "nickname"
    t.string "address"
    t.string "phone"
    t.boolean "is_admin"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.boolean "accept_data_storage"
    t.string "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "visitors", force: :cascade do |t|
    t.string "session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "votes", force: :cascade do |t|
    t.string "votable_type"
    t.integer "votable_id"
    t.string "voter_type"
    t.integer "voter_id"
    t.boolean "vote_flag"
    t.string "vote_scope"
    t.integer "vote_weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
    t.index ["votable_type", "votable_id"], name: "index_votes_on_votable"
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"
    t.index ["voter_type", "voter_id"], name: "index_votes_on_voter"
  end
end
