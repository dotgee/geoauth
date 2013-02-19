class CreateRoleProperties < ActiveRecord::Migration
  def change
    create_table :role_props do |t|
      t.references :role
      t.string :rolename, :null => false
      t.string :propname, :null => false
      t.string :propvalue, :null => false

      t.timestamps
    end

    add_index :role_props, :role_id
  end
end
