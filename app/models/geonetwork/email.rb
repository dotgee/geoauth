module Geonetwork
  class Email < ActiveRecord::Base
    establish_connection :geonetwork
    self.table_name = :email
  
    belongs_to :user, class_name: 'Geonetwork::User'

    scope :by_email, ->(email)  { where(email: email) }
  
  end
end
