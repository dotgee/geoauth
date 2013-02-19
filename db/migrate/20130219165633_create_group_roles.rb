class CreateGroupRoles < ActiveRecord::Migration
  def change
    create_table :group_roles do |t|
      t.references :group
      t.references :role
      t.string :groupname
      t.timestamps
    end
    add_index :group_roles, [ :groupname, :role_id], :unique => true
    add_index :group_roles, [ :group_id, :role_id], :unique => true
  end
end
