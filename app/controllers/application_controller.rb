class ApplicationController < ActionController::Base
  protect_from_forgery
  include SentientController

  LOGOUT_PATHS = [ '/geoserver/j_spring_security_logout' ]
  AUTOLOGIN_PATHS = [ '/autologin' ]

  layout :choose_layout

  def root

    #
    # Avoid infinite loop
    #
    request_path = ( [ '/', ] + AUTOLOGIN_PATHS ).include?(request.env['REQUEST_PATH']) ? '/geoserver/' :  request.env['REQUEST_PATH']
    #request_path = request_path || request.original_url 
    #logger.info "################ HTTP REFERER: #{request.env['HTTP_REFERER']}"
    #logger.info "################ SESSION : #{session[:referer]}"
    #logger.info "################ Request path: #{request_path}"

    #
    # stop if already redirect to /internal
    #

    not_found and return if internal_path?
 
    if login_request?
      true
    end

    if user_signed_in?
      response.headers['X-Authenticated-User'] = current_user.email
      if request_path.starts_with?('/geonetwork')
        geonetwork_user = GeonetworkUser.find_or_create_by_user(current_user)

        response.headers['X-Authenticated-lastname'] = current_user.last_name
        response.headers['X-Authenticated-firstname'] = current_user.first_name
        response.headers['X-Authenticated-profile'] = geonetwork_user.nil? ? 'RegisteredUser' : geonetwork_user.profile
        response.headers['X-Authenticated-group'] = 'Users'
        if !session["geonetwork_connected"]
          session["geonetwork_connected"] = true
          redirect_to "/geonetwork/" and return
	      end
      end
    else
      #
      # Geonetwork authentication without being authenticated first.
      # Redirect to autologin path
      #
      if request_path.starts_with?('/geonetwork/srv/eng/shib.user')
        session["geouser_return_to"] = request_path
        session["geonetwork_connected"] = true
	      # store_location!
       	redirect_to AUTOLOGIN_PATHS.first and return
      end
    end

    if !user_signed_in? && LOGOUT_PATHS.include?(request.env['REQUEST_PATH'])
      session.delete("geonetwork_connected")
      cookies.delete('JSESSIONID', path: '/geoserver')
      cookies.delete('SPRING_SECURITY_REMEMBER_ME_COOKIE', path: '/geoserver')
      cookies.delete('JSESSIONID', path: '/geonetwork')
    end
    response.headers['X-Accel-Redirect'] = "/internal#{[ request_path, request.env['QUERY_STRING'] ].reject { |item| item.blank? }.compact.join('?')}"

    #logger.info response.headers.inspect

    render :nothing => true
  end


  protected

  def choose_layout
    "application"
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  #
  # Force logout on every apps
  #
  def sso_logout
    if !user_signed_in?
      session.delete("geonetwork_connected")
      cookies.delete('JSESSIONID', path: '/geoserver')
      cookies.delete('SPRING_SECURITY_REMEMBER_ME_COOKIE', path: '/geoserver')
      cookies.delete('JSESSIONID', path: '/geonetwork')
    end
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
    #
    # It's not the best place to handle full sso logout, but this method
    # should be called after every logout
    #
    sso_logout
    root_path
  end

  def after_sign_in_path_for(resource_or_scope)
    #geonetwork_path = session.delete("geouser_return_to")
    #geonetwork_path || stored_location_for(resource_or_scope) || signed_in_root_path(resource_or_scope)
    #logger.info "Devise redirect : #{session[:referer]}"
    session[:referer] || root_path
  end

  def internal_path?
    request_path.starts_with?('/internal')
  end

  def login_request?
    #
    # spring
    #
    if request_path.match('/x_j_spring_security_check') && request.post?
      # user = User.new(email: params[:username], password: params[:password])
      @user = warden.authenticate!(scope: :user, recall: 'devise/sessions#new')
      sign_in(:user, @user)
    end
  end

  def request_path
    request.env['REQUEST_PATH']
  end
end
