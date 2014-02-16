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

ActiveRecord::Schema.define(version: 20140216143921) do

  create_table "users", force: true do |t|
    t.string   "twitter_id"
    t.string   "twitter_access_token"
    t.string   "twitter_access_secret"
    t.string   "url_id_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["twitter_id"], name: "index_users_on_twitter_id"
  add_index "users", ["url_id_hash"], name: "index_users_on_url_id_hash"

end
