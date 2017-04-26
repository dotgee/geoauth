class AddEnitityToGroups < ActiveRecord::Migration
  def change
		add_column :groups, :entity, :boolean, default: false
    add_index  :groups, :entity
  end
end
