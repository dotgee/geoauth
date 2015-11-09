module Admin
  class DashboardController < BaseController
    def index
      redirect_to admin_users_path
    end
  end
end
