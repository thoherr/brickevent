class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :authenticate_user!
  before_action :get_lug
  before_action :set_context
  before_action :mailer_set_url_options
  before_action :configure_permitted_user_parameters, if: :devise_controller?

  def self.supported_locales
    [ :de, :en ]
  end

  def set_context
    set_locale
    @stage = ENV["STAGE"] || "prod"
  end 

  def set_locale
    I18n.locale = params[:locale] || extract_locale_from_accept_language_header || I18n.default_locale
    I18n.locale = I18n.default_locale unless ApplicationController.supported_locales.include? I18n.locale
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

  def mailer_set_url_options
    # the URLs in our (confirmation) mails should link to the current instance, which can (will) differ for different LUGs
    # see http://stackoverflow.com/questions/3432712/how-to-set-the-actionmailer-default-url-optionss-host-dynamically-to-the-reque
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  protected

  def configure_permitted_user_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone, :lug, :nickname, :address, :accept_data_storage])
  end

  private
  def extract_locale_from_accept_language_header
    http_accept_language = request.env['HTTP_ACCEPT_LANGUAGE']
    return http_accept_language.scan(/^[a-z]{2}/).first if http_accept_language
    nil
  end

end
