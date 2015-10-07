class CheckAuthController < ApplicationController
  before_action :authenticate_user!, only: [:authenticated]
  before_action :set_user, only: [:authenticated]

  layout 'geoauth_login'

  def authenticated
  end

  def not_authenticated
  end

  private

  def set_user
    @user = current_user
  end
end
