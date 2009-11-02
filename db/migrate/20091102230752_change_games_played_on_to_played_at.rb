class ChangeGamesPlayedOnToPlayedAt < ActiveRecord::Migration
  def self.up
    rename_column :games, :played_on, :played_at
    change_column :games, :played_at, :datetime
  end

  def self.down
    change_column :games, :played_at, :date
    rename_column :games, :played_at, :played_on
  end
end
