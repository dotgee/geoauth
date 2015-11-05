module Devise
  class GeoauthSessionsController < Devise::SessionsController
    before_filter :save_referer

    def destroy
      logger.info "Delete all cookies"
      session.delete("geonetwork_connected")
      cookies.delete('JSESSIONID', path: '/geoserver')
      cookies.delete('SPRING_SECURITY_REMEMBER_ME_COOKIE', path: '/geoserver')
      cookies.delete('SPRING_SECURITY_REMEMBER_ME_COOKIE', path: '/geonetwork')
      cookies.delete('JSESSIONID', path: '/geonetwork')
      # cookies['JSESSIONID'] = { value: nil, expires: Time.now, path: '/geoserver' }

      super
      # super do
      #   logger.info "Delete all cookies"
      #   session.delete("geonetwork_connected")
      #   cookies.delete('JSESSIONID', path: '/geoserver')
      #   cookies.delete('SPRING_SECURITY_REMEMBER_ME_COOKIE', path: '/geoserver')
      #   cookies.delete('SPRING_SECURITY_REMEMBER_ME_COOKIE', path: '/geonetwork')
      #   cookies.delete('JSESSIONID', path: '/geonetwork')
      #   cookies.delete('zboubiblo')
      # end
    end

    def destroy_cookie
      path = "/#{params[:path]}"
      logger.info "Delete cookies for #{path}"
      cookies.delete('JSESSIONID', path: path)
      cookies.delete('SPRING_SECURITY_REMEMBER_ME_COOKIE', path: path)

      redirect_to path
    end

    private
    def save_referer
      session[:referer] = request.env['HTTP_REFERER']
    end
  end
end
