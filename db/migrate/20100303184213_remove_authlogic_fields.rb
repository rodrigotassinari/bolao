class RemoveAuthlogicFields < ActiveRecord::Migration
  def self.up
    remove_column :users, "login"
    remove_column :users, "email"
    remove_column :users, "crypted_password"
    remove_column :users, "password_salt"
    remove_column :users, "persistence_token"
    remove_column :users, "single_access_token"
    remove_column :users, "perishable_token"
    remove_column :users, "login_count"
    remove_column :users, "failed_login_count"
    remove_column :users, "last_request_at"
    remove_column :users, "current_login_at"
    remove_column :users, "last_login_at"
    remove_column :users, "current_login_ip"
    remove_column :users, "last_login_ip"
  end

  def self.down
    add_column :users, "login", :string, :null => false
    add_column :users, "email", :string, :null => false
    add_column :users, "crypted_password", :string, :null => false
    add_column :users, "password_salt", :string, :null => false
    add_column :users, "persistence_token", :string, :null => false
    add_column :users, "single_access_token", :string, :null => false
    add_column :users, "perishable_token", :string, :null => false
    add_column :users, "login_count", :integer, :default => 0, :null => false
    add_column :users, "failed_login_count", :integer, :default => 0, :null => false
    add_column :users, "last_request_at", :datetime
    add_column :users, "current_login_at", :datetime
    add_column :users, "last_login_at", :datetime
    add_column :users, "current_login_ip", :string
    add_column :users, "last_login_ip", :string
  end
end

