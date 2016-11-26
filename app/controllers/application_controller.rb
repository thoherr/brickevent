class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!
  before_filter :get_lug

  def store_referrer
    session[:return_to] = request.referrer if request.get? and controller_name != "user_sessions" and controller_name != "sessions"
  end

  def redirect_back_or_default(default, options = {})
    redirect_to(session[:return_to] || default, options)
  end

  def get_lug
    Lug.find_each do |l|
      if request.host.end_with? l.request_pattern
        @lug = l
        return
      end
    end
    # stupid default, just for test purposes
    @lug = Lug.first
  end

end
