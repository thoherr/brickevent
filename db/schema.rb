# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130801203235) do

  create_table "accommodation_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "accommodations", :force => true do |t|
    t.integer  "attendance_id"
    t.integer  "accommodation_type_id"
    t.integer  "count"
    t.text     "remarks",               :limit => 65384
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attendances", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attendances", ["user_id", "event_id"], :name => "index_attendances_on_user_id_and_event_id", :unique => true

  create_table "attendee_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attendees", :force => true do |t|
    t.integer  "attendance_id"
    t.integer  "attendee_type_id"
    t.string   "name"
    t.string   "lug"
    t.string   "nickname"
    t.string   "email"
    t.boolean  "afols_event"
    t.text     "remarks",          :limit => 65384
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shirt_size"
  end

  create_table "builders", :force => true do |t|
    t.integer  "exhibit_id"
    t.integer  "attendee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.text     "description",       :limit => 65384
    t.string   "location"
    t.string   "url"
    t.string   "lug"
    t.boolean  "registration_open"
    t.date     "start_date"
    t.date     "end_date"
    t.text     "remarks",           :limit => 65384
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "has_accomodation"
    t.boolean  "has_event_shirt"
    t.boolean  "has_accommodation"
  end

  create_table "exhibits", :force => true do |t|
    t.integer  "attendance_id"
    t.string   "name"
    t.text     "description",             :limit => 65384
    t.string   "url"
    t.string   "size_studs"
    t.string   "size"
    t.integer  "value"
    t.string   "building_hours"
    t.integer  "brick_count"
    t.boolean  "needs_power_supply"
    t.boolean  "needs_transportation"
    t.boolean  "is_installation"
    t.boolean  "is_part_of_installation"
    t.integer  "installation_exhibit_id"
    t.text     "remarks",                 :limit => 65384
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.string   "lug"
    t.string   "nickname"
    t.string   "address"
    t.string   "phone"
    t.boolean  "is_admin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.boolean  "accept_data_storage"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
