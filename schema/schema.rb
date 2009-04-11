# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 5) do

  create_table "entries", :force => true do |t|
    t.integer  "sheet_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "kind",                  :default => "image"
    t.string   "value"
    t.string   "identifier"
    t.datetime "identifier_expired_on"
  end

  create_table "game_users", :force => true do |t|
    t.integer "game_id"
    t.integer "user_id"
  end

  create_table "games", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "owner_id"
    t.integer  "turns"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sheets", :force => true do |t|
    t.integer  "game_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code"
    t.datetime "activated_at"
    t.string   "password_reset_code"
    t.string   "identity_url"
    t.string   "name"
    t.string   "email"
    t.string   "website"
    t.string   "location"
    t.string   "zip"
    t.string   "title"
    t.string   "company"
    t.text     "about"
  end

end
