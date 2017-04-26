class AddPbkdf2PasswordToUsers < ActiveRecord::Migration
  def change
		add_column :users, :pbkdf2_password, :string, null: true
  end
end
