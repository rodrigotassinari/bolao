class AddBonusBetsCountToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :bonus_bets_count, :integer, :default => 0
    add_column :bonus, :bonus_bets_count, :integer, :default => 0
  end

  def self.down
    remove_column :users, :bonus_bets_count
    remove_column :bonus, :bonus_bets_count
  end
end
