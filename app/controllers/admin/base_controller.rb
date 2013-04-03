module Admin
  class BaseController < ApplicationController
    #before_filter :authenticate_user!, :check_admin_role!

    private
      def check_admin_role!
        if current_user.nil? || !current_user.has_role?(:ROLE_ADMINISTRATOR)
          redirect_to :root
        end
        true
      end
  end
end
