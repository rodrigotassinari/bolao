class CreateBonusBets < ActiveRecord::Migration
  def self.up
    create_table :bonus_bets do |t|
      t.integer :user_id, :null => false
      t.integer :bonus_id, :null => false
      t.string :answer, :null => false
      t.integer :points
      t.datetime :scored_at

      t.timestamps
    end

    add_index :bonus_bets, :user_id
    add_index :bonus_bets, :bonus_id
    add_index :bonus_bets, :answer
  end

  def self.down
    drop_table :bonus_bets
  end
end
