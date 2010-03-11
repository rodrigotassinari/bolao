# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100309140912) do

  create_table "bets", :force => true do |t|
    t.integer  "user_id",                            :null => false
    t.integer  "game_id",                            :null => false
    t.integer  "goals_a"
    t.integer  "goals_b"
    t.boolean  "penalty",         :default => false
    t.integer  "penalty_goals_a"
    t.integer  "penalty_goals_b"
    t.integer  "winner_id"
    t.integer  "loser_id"
    t.boolean  "tie",             :default => false
    t.integer  "points"
    t.datetime "scored_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bets", ["game_id"], :name => "index_bets_on_game_id"
  add_index "bets", ["loser_id"], :name => "index_bets_on_loser_id"
  add_index "bets", ["penalty"], :name => "index_bets_on_penalty"
  add_index "bets", ["tie"], :name => "index_bets_on_tie"
  add_index "bets", ["user_id"], :name => "index_bets_on_user_id"
  add_index "bets", ["winner_id"], :name => "index_bets_on_winner_id"

  create_table "games", :force => true do |t|
    t.string   "stadium"
    t.string   "city"
    t.datetime "played_at",                          :null => false
    t.string   "stage",                              :null => false
    t.integer  "team_a_id"
    t.integer  "team_b_id"
    t.integer  "goals_a"
    t.integer  "goals_b"
    t.boolean  "penalty",         :default => false
    t.integer  "penalty_goals_a"
    t.integer  "penalty_goals_b"
    t.integer  "winner_id"
    t.integer  "loser_id"
    t.boolean  "tie",             :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "games", ["loser_id"], :name => "index_games_on_loser_id"
  add_index "games", ["penalty"], :name => "index_games_on_penalty"
  add_index "games", ["played_at"], :name => "index_games_on_played_at"
  add_index "games", ["stage"], :name => "index_games_on_stage"
  add_index "games", ["team_a_id"], :name => "index_games_on_team_a_id"
  add_index "games", ["team_b_id"], :name => "index_games_on_team_b_id"
  add_index "games", ["tie"], :name => "index_games_on_tie"
  add_index "games", ["winner_id"], :name => "index_games_on_winner_id"

  create_table "teams", :force => true do |t|
    t.string   "name",                    :null => false
    t.string   "acronym",    :limit => 3, :null => false
    t.string   "group",      :limit => 1, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["acronym"], :name => "index_teams_on_acronym", :unique => true
  add_index "teams", ["group"], :name => "index_teams_on_group"
  add_index "teams", ["name"], :name => "index_teams_on_name", :unique => true

  create_table "users", :force => true do |t|
    t.string   "name",                                                  :null => false
    t.boolean  "admin",                              :default => false
    t.datetime "paid_at"
    t.string   "payment_code"
    t.integer  "points_cache",                       :default => 0
    t.string   "email",                                                 :null => false
    t.string   "encrypted_password",   :limit => 40,                    :null => false
    t.string   "password_salt",                                         :null => false
    t.string   "reset_password_token", :limit => 20
    t.string   "remember_token",       :limit => 20
    t.datetime "remember_created_at"
    t.integer  "sign_in_count"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["name"], :name => "index_users_on_name", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
