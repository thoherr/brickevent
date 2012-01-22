class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!

  def store_referrer
    session[:return_to] = request.referrer if request.get? and controller_name != "user_sessions" and controller_name != "sessions"
  end

  def redirect_back_or_default(default, options = {})
    redirect_to(session[:return_to] || default, options)
  end

end
