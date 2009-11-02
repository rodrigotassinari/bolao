class AddPaidAndPointsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :paid_at, :datetime
    add_column :users, :points_cache, :integer, :default => 0
  end

  def self.down
    add_column :users, :paid_at
    add_column :users, :points_cache
  end
end
