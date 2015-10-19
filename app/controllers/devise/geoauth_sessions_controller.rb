module Devise
  class GeoauthSessionsController < Devise::SessionsController
    before_filter :save_referer

    def destroy
      super do
        logger.info "Delete all cookies"
        session.delete("geonetwork_connected")
        cookies.delete('JSESSIONID', path: '/geoserver')
        cookies.delete('SPRING_SECURITY_REMEMBER_ME_COOKIE', path: '/geoserver')
        cookies.delete('SPRING_SECURITY_REMEMBER_ME_COOKIE', path: '/geonetwork')
        cookies.delete('JSESSIONID', path: '/geonetwork')
      end
    end

    private
    def save_referer
      session[:referer] = request.env['HTTP_REFERER']
    end
  end
end
