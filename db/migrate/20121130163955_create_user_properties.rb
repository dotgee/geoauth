class CreateUserProperties < ActiveRecord::Migration
  def change
    create_table :user_props do |t|
      t.references :user
      t.string :username
      t.string :propname, :null => false
      t.string :propvalue, :null => false
      t.timestamps
    end
    add_index :user_props, :user_id
  end
end
