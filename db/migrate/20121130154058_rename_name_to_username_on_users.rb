class User < ActiveRecord::Base
end

class RenameNameToUsernameOnUsers < ActiveRecord::Migration
  def change
    if User.column_names.include?('name')
      User.all.each do |user|
        user.name = user.email
        user.save!
      end
    end

    rename_column :users, :name, :username
    change_column :users, :username, :string, :null => false
    add_index :users, :username, :unique => true
  end
end
