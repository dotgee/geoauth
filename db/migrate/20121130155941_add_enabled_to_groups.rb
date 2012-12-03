class AddEnabledToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :enabled, :boolean, :default => true
  end
end
