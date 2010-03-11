class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.string :stadium
      t.string :city
      t.datetime :played_at, :null => false
      t.string  :stage, :null => false
      t.integer :team_a_id
      t.integer :team_b_id
      t.integer :goals_a
      t.integer :goals_b
      t.boolean :penalty, :default => false
      t.integer :penalty_goals_a
      t.integer :penalty_goals_b
      t.integer :winner_id
      t.integer :loser_id
      t.boolean :tie, :default => false
      
      t.integer  "bets_count", :default => 0

      t.timestamps
    end
    
    add_index :games, :stage
    add_index :games, :winner_id
    add_index :games, :loser_id
    add_index :games, :played_at
    add_index :games, :penalty
    add_index :games, :tie
    add_index :games, :team_a_id
    add_index :games, :team_b_id
  end

  def self.down
    drop_table :games
  end
end

