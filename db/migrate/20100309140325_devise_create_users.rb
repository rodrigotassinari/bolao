class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.string :name, :null => false
      t.boolean  "admin", :default => false
      t.datetime "paid_at"
      t.string "payment_code"
      t.integer  "points_cache", :default => 0
      
      t.authenticatable :encryptor => :sha1, :null => false
      t.recoverable
      t.rememberable
      t.trackable
      #t.confirmable
      #t.lockable
      
      t.timestamps
    end

    add_index :users, :name,                 :unique => true
    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    #add_index :users, :confirmation_token,   :unique => true
    #add_index :users, :unlock_token,         :unique => true
  end

  def self.down
    drop_table :users
  end
end

