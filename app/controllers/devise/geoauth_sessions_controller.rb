module Devise
  class GeoauthSessionsController < Devise::SessionsController
    before_filter :save_referer

    private
    def save_referer
      session[:referer] = request.env['HTTP_REFERER']
    end
  end
end
