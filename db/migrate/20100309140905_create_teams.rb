class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.string :name, :null => false
      t.string :acronym, :limit => 3, :null => false
      t.string :group, :limit => 1, :null => false

      t.timestamps
    end
    
    add_index :teams, :name, :unique => true
    add_index :teams, :acronym, :unique => true
    add_index :teams, :group
  end

  def self.down
    drop_table :teams
  end
end

