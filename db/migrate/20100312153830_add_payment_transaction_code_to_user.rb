class AddPaymentTransactionCodeToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :payment_transaction_code, :string
    add_index :users, :payment_transaction_code
    add_index :users, :payment_code, :unique => true
  end

  def self.down
    remove_column :users, :payment_transaction_code
    remove_index :users, :payment_transaction_code
    remove_index :users, :payment_code
  end
end

