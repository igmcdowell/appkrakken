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

ActiveRecord::Schema.define(:version => 20111219022314) do

  create_table "apps", :force => true do |t|
    t.string   "name"
    t.decimal  "rating",             :precision => 3, :scale => 2
    t.text     "description"
    t.decimal  "price"
    t.string   "version"
    t.decimal  "size"
    t.integer  "numratings"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "game_center"
    t.string   "artwork60"
    t.string   "dev_site"
    t.string   "dev_name"
    t.datetime "release_date"
    t.string   "primary_genre_name"
    t.text     "release_notes"
    t.integer  "primary_genre_id"
    t.integer  "dev_id"
    t.string   "game_url"
    t.string   "artwork100"
    t.string   "age_rating"
    t.integer  "app_id"
  end

  create_table "genre_codes", :force => true do |t|
    t.integer  "genre"
    t.integer  "app_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "genre_codes", ["app_id"], :name => "index_genre_codes_on_app_id"

  create_table "genres", :force => true do |t|
    t.text     "name"
    t.integer  "app_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "genres", ["app_id"], :name => "index_genres_on_app_id"

  create_table "ipad_screenshot_urls", :force => true do |t|
    t.string   "url"
    t.integer  "app_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ipad_screenshot_urls", ["app_id"], :name => "index_ipad_screenshot_urls_on_app_id"

  create_table "language_codes", :force => true do |t|
    t.string   "language"
    t.integer  "app_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "language_codes", ["app_id"], :name => "index_language_codes_on_app_id"

  create_table "prices", :force => true do |t|
    t.integer  "app_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.decimal  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "prices", ["app_id"], :name => "index_prices_on_app_id"

  create_table "screenshot_urls", :force => true do |t|
    t.string   "url"
    t.integer  "app_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "screenshot_urls", ["app_id"], :name => "index_screenshot_urls_on_app_id"

  create_table "supported_devices", :force => true do |t|
    t.string   "device"
    t.integer  "app_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "supported_devices", ["app_id"], :name => "index_supported_devices_on_app_id"

end
