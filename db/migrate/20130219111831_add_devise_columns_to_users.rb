class AddDeviseColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :remember_token, :string
    add_column :users, :invitation_token, :string
    add_index :users, :remember_token, :unique => true 
  end
end
