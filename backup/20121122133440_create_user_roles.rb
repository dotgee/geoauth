class CreateUserRoles < ActiveRecord::Migration
  def change
    create_table :user_roles do |t|
      t.integer :user_id, :null => true
      t.string :username, :null => false
      t.integer :role_id, :null => false
      t.timestamps
    end

    add_index :user_roles, :user_id
    add_index :user_roles, :username
    add_index :user_roles, :role_id
    add_index :user_roles, [ :username, :role_id ], :unique => true
  end
end
