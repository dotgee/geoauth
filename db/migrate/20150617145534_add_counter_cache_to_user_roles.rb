class AddCounterCacheToUserRoles < ActiveRecord::Migration
  def change
    add_column :users, :roles_count, :integer, default: 0
    add_column :roles, :users_count, :integer, default: 0
  end
end
