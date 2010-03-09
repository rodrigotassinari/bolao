class CreateBets < ActiveRecord::Migration
  def self.up
    create_table :bets do |t|
      t.integer :user_id, :null => false
      t.integer :game_id, :null => false
      t.integer :goals_a
      t.integer :goals_b
      t.boolean :penalty, :default => false
      t.integer :penalty_goals_a
      t.integer :penalty_goals_b
      t.integer :winner_id
      t.integer :loser_id
      t.boolean :tie, :default => false
      t.integer :points, :default => 0

      t.timestamps
    end
    
    add_index :bets, :penalty
    add_index :bets, :tie
    add_index :bets, :user_id
    add_index :bets, :game_id
    add_index :bets, :winner_id
    add_index :bets, :loser_id
  end

  def self.down
    drop_table :bets
  end
end

