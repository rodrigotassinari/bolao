class RedoUsers < ActiveRecord::Migration
  def self.up
    drop_table :users
    create_table(:users) do |t|
      t.facebook_connectable
      
      #t.authenticatable :encryptor => :sha1, :null => false
      #t.rememberable
      t.trackable
      
      t.string   "name"
      t.string   "email"
      t.boolean  "admin", :default => false
      t.text     "preferences"
      t.datetime "paid_at"
      t.integer  "points_cache", :default => 0
      
      t.timestamps
    end
    add_index :users, :facebook_uid, :unique => true
  end

  def self.down
    drop_table :users
    create_table(:users) do |t|
      t.string   "name"
      t.string   "email"
      t.boolean  "admin", :default => false
      t.text     "preferences"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.datetime "paid_at"
      t.integer  "points_cache", :default => 0
    end
  end
end

