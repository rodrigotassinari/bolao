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

ActiveRecord::Schema.define(:version => 20100303184213) do

  create_table "bets", :force => true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "goals_a",         :default => 0
    t.integer  "goals_b",         :default => 0
    t.boolean  "penalty",         :default => false
    t.integer  "penalty_goals_a"
    t.integer  "penalty_goals_b"
    t.integer  "winner_id"
    t.integer  "loser_id"
    t.boolean  "tie",             :default => false
    t.integer  "points",          :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bets", ["game_id"], :name => "index_bets_on_game_id"
  add_index "bets", ["loser_id"], :name => "index_bets_on_loser_id"
  add_index "bets", ["user_id"], :name => "index_bets_on_user_id"
  add_index "bets", ["winner_id"], :name => "index_bets_on_winner_id"

  create_table "games", :force => true do |t|
    t.string   "stadium"
    t.string   "city"
    t.datetime "played_at"
    t.boolean  "group_game",      :default => false
    t.integer  "team_a_id"
    t.integer  "team_b_id"
    t.integer  "goals_a",         :default => 0
    t.integer  "goals_b",         :default => 0
    t.boolean  "penalty",         :default => false
    t.integer  "penalty_goals_a"
    t.integer  "penalty_goals_b"
    t.integer  "winner_id"
    t.integer  "loser_id"
    t.boolean  "tie",             :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "games", ["group_game"], :name => "index_games_on_group_game"
  add_index "games", ["loser_id"], :name => "index_games_on_loser_id"
  add_index "games", ["penalty"], :name => "index_games_on_penalty"
  add_index "games", ["played_at"], :name => "index_games_on_played_on"
  add_index "games", ["team_a_id"], :name => "index_games_on_team_a_id"
  add_index "games", ["team_b_id"], :name => "index_games_on_team_b_id"
  add_index "games", ["tie"], :name => "index_games_on_tie"
  add_index "games", ["winner_id"], :name => "index_games_on_winner_id"

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.string   "acronym",    :limit => 3
    t.string   "group",      :limit => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["acronym"], :name => "index_teams_on_acronym"
  add_index "teams", ["group"], :name => "index_teams_on_group"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.boolean  "admin",        :default => false
    t.text     "preferences"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "paid_at"
    t.integer  "points_cache", :default => 0
  end

end
