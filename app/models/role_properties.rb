class RoleProperties < ActiveRecord::Base
  set_table_name :role_props

  belongs_to :role

  attr_accessible :rolename, :propname, :propvalue
end
