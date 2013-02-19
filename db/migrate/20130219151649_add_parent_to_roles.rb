class AddParentToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :parent, :string, :length => 64
  end
end
