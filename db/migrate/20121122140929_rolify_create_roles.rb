class RolifyCreateRoles < ActiveRecord::Migration
  def change
    create_table(:roles) do |t|
      t.string :name
      t.references :resource, :polymorphic => true
      t.string :description
      t.timestamps
    end

    create_table(:user_roles, :id => true) do |t|
      t.references :user
      t.references :role
      t.string :username, :null => false
      t.timestamps
    end

    add_index(:roles, :name)
    add_index(:roles, [ :name, :resource_type, :resource_id ])
    add_index(:user_roles, [ :user_id, :role_id ])
    add_index(:user_roles, [ :username, :role_id ], unique: true)
  end
end
