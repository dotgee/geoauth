class AddRequestedGroupToUsers < ActiveRecord::Migration
  def change
		add_column :users, :requested_group_id, :integer, null: true
  end
end
