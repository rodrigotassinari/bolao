class CreateBets < ActiveRecord::Migration
  def self.up
    create_table :bets do |t|
      t.integer :user_id
      t.integer :game_id
      t.integer :goals_a, :default => 0
      t.integer :goals_b, :default => 0
      t.boolean :penalty, :default => false
      t.integer :penalty_goals_a
      t.integer :penalty_goals_b
      t.integer :winner_id
      t.integer :loser_id
      t.boolean :tie, :default => false
      t.integer :points, :default => 0

      t.timestamps
    end

    add_index :bets, :user_id
    add_index :bets, :game_id
    add_index :bets, :winner_id
    add_index :bets, :loser_id
  end

  def self.down
    drop_table :bets
  end
end
