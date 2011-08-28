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

ActiveRecord::Schema.define(:version => 20110828120858) do

  create_table "events", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.string   "description"
    t.string   "location"
    t.string   "url"
    t.string   "lug"
    t.boolean  "registration_open"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "remarks"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exhibits", :force => true do |t|
    t.integer  "registration_id"
    t.string   "name"
    t.string   "description"
    t.string   "url"
    t.string   "size_studs"
    t.string   "size"
    t.integer  "value"
    t.boolean  "needs_power_supply"
    t.boolean  "needs_transportation"
    t.boolean  "is_installation"
    t.boolean  "is_part_of_installation"
    t.integer  "installation_exhibit_id"
    t.string   "remarks"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "registrations", :force => true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.integer  "number_of_attendees"
    t.boolean  "attend_afols_evening"
    t.integer  "number_of_attendees_afols_evening"
    t.boolean  "wants_hotel_reservation"
    t.string   "remarks"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password"
    t.string   "fullname"
    t.string   "lug"
    t.string   "nickname"
    t.string   "address"
    t.string   "phone"
    t.boolean  "is_admin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
