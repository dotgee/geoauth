class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name, :null => false
      t.string :description
      t.timestamps
    end

    add_index :groups, :name, :unique => true

    create_table(:users_groups, :id => false) do |t|
      t.references :user
      t.references :group
    end

    add_index :users_groups, [ :user_id, :group_id ]
  end
end
