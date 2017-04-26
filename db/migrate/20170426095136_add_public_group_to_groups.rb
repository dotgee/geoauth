class AddPublicGroupToGroups < ActiveRecord::Migration
  def change
		add_column :groups, :public, :boolean, default: false

		add_index :groups, :public
  end
end
