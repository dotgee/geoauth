class GeonetworkUser < ActiveRecord::Base
  establish_connection :geonetwork
  set_table_name :users

  scope :by_username, lambda  { |u| where(username: u) }

  def self.find_or_create_by_user(user)
    g_user = self.where(username: user.email).first_or_create do |gu|
      gu.id = self.unscoped.maximum(:id) + 1
      gu.password = '*LCK*'
      gu.surname = user.first_name
      gu.name = user.last_name
      gu.profile = 'RegisteredUser'
      gu.organisation = 'OSUR'
      gu.email = user.email
      # gu.authtype = 'geoauth'
      # gu.security = 'update_hash_required'
    end
  end
end
