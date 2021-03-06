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

ActiveRecord::Schema.define(version: 20131112201952) do

  create_table "commits", force: true do |t|
    t.boolean  "test_pushed",                default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pull_request_id"
    t.string   "sha",             limit: 40
  end

  create_table "pull_requests", force: true do |t|
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "open",       default: true
  end

  add_index "pull_requests", ["number"], name: "index_pull_requests_on_number", unique: true

end
