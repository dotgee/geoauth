class UserProperty < ActiveRecord::Base
  attr_accessible :propname, :propvalue, :username, :users
end
