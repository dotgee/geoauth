class HomeController < ApplicationController
  def index
  end

  #
  # handle redirection based on configuration when accessing '/'
  #
  def redirect
    redirect_to Settings.default_redirect_after_login and return
  end

  def check
  end
end
