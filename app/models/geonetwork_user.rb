class GeonetworkUser < ActiveRecord::Base
  establish_connection :geonetwork
  set_table_name :users

  scope :by_username, lambda  { |u| where(username: u) }
end
