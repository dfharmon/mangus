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

ActiveRecord::Schema.define(:version => 20130825212956) do

  create_table "bets", :force => true do |t|
    t.integer  "game_id"
    t.integer  "user_id"
    t.integer  "amount"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.boolean  "won"
    t.integer  "pick_team_id"
    t.boolean  "counted",      :default => false
  end

  create_table "games", :force => true do |t|
    t.string   "favorite_id"
    t.string   "spread"
    t.string   "home_team_id"
    t.integer  "home_score"
    t.string   "away_team_id"
    t.integer  "away_score"
    t.datetime "start_date"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "week"
    t.boolean  "final"
  end

  create_table "standings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "week"
    t.integer  "wins"
    t.integer  "losses"
    t.integer  "total_cash"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "teams", :force => true do |t|
    t.string   "location"
    t.string   "mascot"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "admin",                  :default => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "total_cash",             :default => 0
    t.string   "name"
    t.string   "avatar"
    t.integer  "wins",                   :default => 0
    t.integer  "losses",                 :default => 0
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
