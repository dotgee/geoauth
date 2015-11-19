class ApplicationController < ActionController::Base
  protect_from_forgery
  include SentientController
  include Devise::Controllers::StoreLocation

  before_action :configure_permitted_parameters, if: :devise_controller?

  LOGOUT_PATHS = [ /\/j_spring_security_logout/ ]
  LOGOUT_PATHS_RE = Regexp.union(LOGOUT_PATHS)
  AUTOLOGIN_PATHS = [ '/autologin' ]

  layout :choose_layout

  def root

    #
    # handle logout
    #
    logger.info "Before check logout #{user_signed_in?} #{request_path} #{LOGOUT_PATHS_RE}"
    if user_signed_in? && request_path.match(LOGOUT_PATHS_RE) #.include?( request_path )
      store_location_for(current_user, request_path)
      logger.info "redirect to logout : #{request_path}"
      redirect_to '/logout' and return
    end

    #
    # Avoid infinite loop
    #
    rpath = ( [ '/', ] + AUTOLOGIN_PATHS ).include?(request_path) ? '/geoserver/' :  request_path
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
      if rpath.starts_with?('/geonetwork')
        geonetwork_user = Geonetwork::User.find_or_create_by_user(current_user)

        response.headers['X-Authenticated-lastname'] = current_user.last_name
        response.headers['X-Authenticated-firstname'] = current_user.first_name
        # response.headers['X-Authenticated-profile'] = geonetwork_user.nil? ? 'RegisteredUser' : geonetwork_user.profile
        # response.headers['X-Authenticated-group'] = 'Users'
        # if !session["geonetwork_connected"]
        #   session["geonetwork_connected"] = true
        #   redirect_to "/geonetwork/" and return
	      # end
      end
    else
      #
      # Geonetwork authentication without being authenticated first.
      # Redirect to autologin path
      #
      if rpath.starts_with?('/geonetwork/srv/eng/shib.user')
        session["geouser_return_to"] = rpath
        session["geonetwork_connected"] = true
	      # store_location!
       	redirect_to AUTOLOGIN_PATHS.first and return
      end
    end

    # after_sign_out_path not called...
    if !user_signed_in? && LOGOUT_PATHS.include?(request_path)
      session.delete("geonetwork_connected")
      cookies.delete('JSESSIONID', path: '/geoserver')
      cookies.delete('SPRING_SECURITY_REMEMBER_ME_COOKIE', path: '/geoserver')
      cookies.delete('JSESSIONID', path: '/geonetwork')
    end
    response.headers['X-Accel-Redirect'] = "/internal#{[ rpath, request.env['QUERY_STRING'] ].reject { |item| item.blank? }.compact.join('?')}"

    logger.info response.headers.inspect

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
    logger.info "sso_logout #{request_path} #{user_signed_in?}"
    if !user_signed_in?
      session.delete("geonetwork_connected")
      cookies.delete('JSESSIONID', path: '/geoserver')
      cookies.delete('SPRING_SECURITY_REMEMBER_ME_COOKIE', path: '/geoserver')
      cookies.delete('SPRING_SECURITY_REMEMBER_ME_COOKIE', path: '/geonetwork')
      cookies.delete('JSESSIONID', path: '/geonetwork')
      logger.info "blu - Cookies deleted"
    end
  end

  private

  #
  # Devise specific
  # Overwriting the sign_out redirect path method
  #
  def after_sign_out_path_for(resource_or_scope)
    # if LOGOUT_PATHS.include?(request.env['REQUEST_PATH'])
    #   return request.env['REQUEST_PATH']
    # end
    #
    # It's not the best place to handle full sso logout, but this method
    # should be called after every logout
    #
    return_path = stored_location_for(resource_or_scope)
    return_path ||= request.referer
    return_path ||= root_path
	# root_path

    logger.info "after_sign_out_path_for #{request.path}"
    # put it in sessionscontroller
    sso_logout

    return_path
  end

  def after_sign_in_path_for(resource_or_scope)
    # specific to geoauth
    # session[:referer] || root_path

    #
    # @see https://github.com/plataformatec/devise/wiki/How-To:-redirect-to-a-specific-page-on-successful-sign-in
    #
    return request.env['omniauth.origin'] if request.env['omniauth.origin']

    #
    # not from omniauth
    #
    sign_in_url = new_user_session_url
    if request.referer == sign_in_url
      super
    else
      stored_location_for(resource_or_scope) || request.referer || '/' # root_path
    end
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
    # return ( request.env['REQUEST_PATH'].nil? == true ) ? request.env['REQUEST_URI'] : request.env['REQUEST_PATH']
    return request.env['REQUEST_URI'].gsub(/\?.*/, '')
    return ( request.env['REQUEST_PATH'].nil? == true ) ? request.env['REQUEST_URI'].gsub(/\?.*/, '') : request.env['REQUEST_PATH']
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  #
  # for strong parameters with devise
  #
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :username
  end

  def ensure_signup_complete
    # Ensure we don't go into an infinite loop
    return if action_name == 'finish_signup'

    # Redirect to the 'finish_signup' page if the user
    # email hasn't been verified yet
    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path(current_user)
    end
  end

end
