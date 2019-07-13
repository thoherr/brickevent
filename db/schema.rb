# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20190713192809) do

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
    t.boolean  "is_approved"
  end

  add_index "attendances", ["user_id", "event_id"], :name => "index_attendances_on_user_id_and_event_id", :unique => true

  create_table "attendee_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_visible"
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
    t.boolean  "is_approved"
    t.boolean  "needs_ticket",                      :default => true
    t.boolean  "option_1",                          :default => false
    t.boolean  "option_2",                          :default => false
    t.boolean  "option_3",                          :default => false
    t.boolean  "option_4",                          :default => false
    t.boolean  "option_5",                          :default => false
  end

  create_table "builders", :force => true do |t|
    t.integer  "exhibit_id"
    t.integer  "attendee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_managers", :force => true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.text     "description",               :limit => 65384
    t.string   "location"
    t.string   "url"
    t.string   "lugname"
    t.boolean  "registration_open"
    t.date     "start_date"
    t.date     "end_date"
    t.text     "remarks",                   :limit => 65384
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "has_event_shirt"
    t.boolean  "has_accommodation"
    t.boolean  "has_moc_card_service"
    t.string   "logo_url"
    t.boolean  "visible"
    t.boolean  "has_moc_transport"
    t.integer  "lug_id"
    t.boolean  "has_afols_event",                            :default => true
    t.boolean  "has_tickets",                                :default => true
    t.boolean  "has_option_1"
    t.string   "label_option_1"
    t.boolean  "has_option_2"
    t.string   "label_option_2"
    t.boolean  "has_option_3"
    t.string   "label_option_3"
    t.text     "additional_information",    :limit => 65384
    t.boolean  "has_option_4"
    t.string   "label_option_4"
    t.boolean  "has_option_5"
    t.string   "label_option_5"
    t.boolean  "edit_of_attendees_allowed",                  :default => false
    t.boolean  "edit_of_exhibits_allowed",                   :default => false
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
    t.integer  "size_x"
    t.integer  "size_y"
    t.integer  "size_z"
    t.integer  "unit_id"
    t.decimal  "size_x_meter"
    t.decimal  "size_y_meter"
    t.decimal  "size_z_meter"
    t.integer  "former_exhibit_id"
    t.boolean  "is_approved"
  end

  create_table "lugs", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "url"
    t.string   "logo_url"
    t.string   "info_mail"
    t.string   "request_pattern"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "impress_url"
    t.string   "favicon_url"
  end

  create_table "units", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "factor"
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
