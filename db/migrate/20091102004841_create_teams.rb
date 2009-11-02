class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.string :name
      t.string :acronym, :limit => 3
      t.string :group, :limit => 1

      t.timestamps
    end

    add_index :teams, :acronym
    add_index :teams, :group
  end

  def self.down
    drop_table :teams
  end
end
