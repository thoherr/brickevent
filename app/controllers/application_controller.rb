class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!
  before_filter :get_lug
  before_filter :set_locale

  def supported_locales
    [ :de, :en ]
  end

  def set_locale
    I18n.locale = params[:locale] || extract_locale_from_accept_language_header || I18n.default_locale
    I18n.locale = I18n.default_locale unless supported_locales.include? I18n.locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

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

  private
  def extract_locale_from_accept_language_header
    http_accept_language = request.env['HTTP_ACCEPT_LANGUAGE']
    return http_accept_language.scan(/^[a-z]{2}/).first if http_accept_language
    nil
  end

end
