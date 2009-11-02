class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.string :stadium
      t.string :city
      t.date :played_on
      t.boolean :group_game, :default => false
      t.integer :team_a_id
      t.integer :team_b_id
      t.integer :goals_a, :default => 0
      t.integer :goals_b, :default => 0
      t.boolean :penalty, :default => false
      t.integer :penalty_goals_a
      t.integer :penalty_goals_b
      t.integer :winner_id
      t.integer :loser_id
      t.boolean :tie, :default => false

      t.timestamps
    end

    add_index :games, :played_on
    add_index :games, :group_game
    add_index :games, :team_a_id
    add_index :games, :team_b_id
    add_index :games, :penalty
    add_index :games, :winner_id
    add_index :games, :loser_id
    add_index :games, :tie
  end

  def self.down
    drop_table :games
  end
end
