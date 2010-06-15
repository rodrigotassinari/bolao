class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :commentable_id
      t.string :commentable_type
      t.integer :user_id
      t.text :body
      t.timestamps
    end

    add_index :comments, [:commentable_type, :commentable_id]
    add_index :comments, :user_id
    add_index :comments, :created_at

    add_column :games, :comments_count, :integer, :default => 0
    add_column :users, :comments_count, :integer, :default => 0
  end

  def self.down
    drop_table :comments

    remove_column :games, :comments_count
    remove_column :users, :comments_count
  end
end
