module Devise
  class GeoauthRegistrationsController < Devise::RegistrationsController
    def create
      super
      if @user.persisted?
        AdminMailer.new_registration(@user).deliver_now
      end
    end
  end
end
