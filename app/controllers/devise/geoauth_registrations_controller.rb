module Devise
  class GeoauthRegistrationsController < Devise::RegistrationsController
    def create
      super
      if @user.persisted?
        AdminMailer.new_registration(@user).deliver_now
      end
    end

    private

    def sign_up_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :comments, { group_ids: [] })
    end

    def account_update_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password)
    end
  end
end
