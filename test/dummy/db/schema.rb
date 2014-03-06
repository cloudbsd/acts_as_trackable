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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131224174648) do

  create_table "blogs", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tracks", force: true do |t|
    t.integer  "tracker_id",     null: false
    t.string   "tracker_type",   null: false
    t.integer  "trackable_id",   null: false
    t.string   "trackable_type", null: false
    t.string   "action",         null: false
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tracks", ["trackable_id", "trackable_type"], name: "index_tracks_on_trackable_id_and_trackable_type"
  add_index "tracks", ["tracker_id", "tracker_type"], name: "index_tracks_on_tracker_id_and_tracker_type"

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
