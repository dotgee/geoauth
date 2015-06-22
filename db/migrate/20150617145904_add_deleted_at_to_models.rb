class AddDeletedAtToModels < ActiveRecord::Migration
  def change
    add_column :users, :deleted_at, :datetime, index: true
    add_column :roles, :deleted_at, :datetime, index: true
    add_column :groups, :deleted_at, :datetime, index: true
  end
end
