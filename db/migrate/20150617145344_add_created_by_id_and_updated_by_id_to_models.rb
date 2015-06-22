class AddCreatedByIdAndUpdatedByIdToModels < ActiveRecord::Migration
  def change
    add_column :users, :created_by_id, :integer
    add_column :users, :updated_by_id, :integer
    add_column :roles, :created_by_id, :integer
    add_column :roles, :updated_by_id, :integer
    add_column :groups, :created_by_id, :integer
    add_column :groups, :updated_by_id, :integer
    add_column :user_roles, :created_by_id, :integer
    add_column :user_roles, :updated_by_id, :integer
  end
end
