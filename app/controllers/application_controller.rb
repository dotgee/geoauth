class ApplicationController < ActionController::Base
  protect_from_forgery

  LOGOUT_PATH = [ '/geoserver/j_spring_security_logout' ]

  def root

    #
    # Avoid infinite loop
    #
    request_path = [ '/', '/login' ].include?(request.env['REQUEST_PATH']) ? '/geoserver/' :  request.env['REQUEST_PATH']

    #
    # stop if already redirect to /internal
    #

    not_found and return if internal_path?
 
    if login_request?
      true
    end

    response.headers['X-Accel-Redirect'] = "/internal#{[ request_path, request.env['QUERY_STRING'] ].reject { |item| item.blank? }.compact.join('?')}"
    # response.headers['X-Authenticated-User'] = user unless user.nil?
    if user_signed_in?
      # response.headers['X-Authenticated-User'] = user_signed_in? ? current_user.email : ''
      response.headers['X-Authenticated-User'] = current_user.email
      if request_path.starts_with?('/geonetwork')
        response.headers['X-Authenticated-lastname'] = current_user.last_name
        response.headers['X-Authenticated-firstname'] = current_user.first_name
        response.headers['X-Authenticated-profile'] = 'Administrator'
      end
    else
      if request_path.starts_with?('/geonetwork/srv/en/shib.user.login')
        redirect_to '/login' and return
      end
    end

    if !user_signed_in? && LOGOUT_PATH.include?(request.env['REQUEST_PATH'])
      cookies.delete('JSESSIONID', path: '/geoserver')
      cookies.delete('SPRING_SECURITY_REMEMBER_ME_COOKIE', path: '/geoserver')
    end
    # response.headers['X-Authenticated-User'] = user_signed_in? ? 'xymox' : ''

    logger.debug response.headers.inspect
    # logger.debug 'X-Authenticated-User'.downcase.gsub(/\-/, '_')

    render :nothing => true
  end


  protected

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  private

  #
  # Devise specific
  # Overwriting the sign_out redirect path method
  #
  def after_sign_out_path_for(resource_or_scope)
    if [ '/geoserver/j_spring_security_logout' ].include?(request.env['REQUEST_PATH'])
      return request.env['REQUEST_PATH']
    end
    root_path
  end


  def internal_path?
    request_path.starts_with?('/internal')
  end

  def login_request?
    #
    # spring
    #
    if request_path.match('/j_spring_security_check') && request.post?
      # user = User.new(email: params[:username], password: params[:password])
      @user = warden.authenticate!(scope: :user, recall: 'devise/sessions#new')
      sign_in(:user, @user)
    end
  end

  def request_path
    request.env['REQUEST_PATH']
  end
end
