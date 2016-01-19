module Geonetwork
  class User < ActiveRecord::Base
    establish_connection :geonetwork
    self.table_name = :users

    has_many :emails, class_name: 'Geonetwork::Email'

    attr_accessor :default_email

    after_commit :save_default_email
  
    scope :by_username, ->(username)  { where(username: username) }
    scope :by_email,    ->(email)     { join(:emails).where('emails.email = ?', email) }

  
    def self.find_or_create_by_user(user)
      g_user = self.where(username: user.email).first_or_create do |gu|
        gu.id = self.unscoped.maximum(:id) + 1
        gu.password = '*LCK*'
        gu.surname = user.first_name
        gu.name = user.last_name
        gu.profile = 4 # 'RegisteredUser' @see https://github.com/geonetwork/core-geonetwork/blob/53127784c90b9753c30427da4146066ea3dace54/domain/src/main/java/org/fao/geonet/domain/Profile.java
        # @todo externalize
        gu.organisation = 'OSUR'
        gu.default_email = user.email
        gu.nodeid = 'srv'
        # gu.emails.build(email: user.email)
        # gu.authtype = 'geoauth'
        # gu.security = 'update_hash_required'
      end
      g.save! unless g.persisted?
    end

    private
    
    def save_default_email
      default_email = self.default_email

      unless default_email.blank? || self.emails.where(email: default_email).any?
        self.emails.build(email: default_email)
        self.save
      end
    end
  end
end
