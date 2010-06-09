class CreateBonus < ActiveRecord::Migration
  def self.up
    create_table :bonus do |t|
      t.string :question, :null => false
      t.string :answer
      t.integer :points_awarded, :null => false
      t.datetime :answer_before, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :bonus
  end
end
