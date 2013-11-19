class UserProperty < ActiveRecord::Base
  set_table_name :user_props
  attr_accessible :propname, :propvalue, :username, :users
end
