class ApplicationController < ActionController::Base
  # Raised when the current user may not see or change a record.
  class NotAuthorized < StandardError; end

  protect_from_forgery with: :exception

  rescue_from NotAuthorized, with: :render_forbidden

  before_action :authenticate_user!
  before_action :store_referrer
  before_action :get_lug
  before_action :set_context
  before_action :set_current_request_host
  before_action :configure_permitted_user_parameters, if: :devise_controller?

  def self.supported_locales
    [ :de, :en ]
  end

  def set_context
    set_locale
    @stage = ENV["STAGE"] || "prod"
  end 

  # The first supported locale of: URL parameter, browser preference, default.
  # Unsupported values are skipped instead of raising I18n::InvalidLocale.
  def set_locale
    requested = [params[:locale], extract_locale_from_accept_language_header].map { |l| l.to_s.downcase.to_sym }
    I18n.locale = requested.find { |l| ApplicationController.supported_locales.include?(l) } || I18n.default_locale
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

  # Links in mails sent during this request (e.g. Devise confirmations) must
  # point to the LUG domain the request came in on. Kept per request in
  # Current instead of the global ActionMailer setting, which parallel
  # requests for different LUG domains would overwrite. See DeviseMailer.
  def set_current_request_host
    Current.host_with_port = request.host_with_port
  end

  protected

  def configure_permitted_user_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:given_name, :family_name, :phone, :lug, :nickname, :address, :accept_data_storage])
  end

  def authorized?(object)
    return false if object.nil? || current_user.nil?

    current_user.is_admin? || !!object.is_managed_by?(current_user)
  end

  # Owner of the record, manager of its event, or admin.
  def authorize!(object)
    raise NotAuthorized unless authorized?(object)
  end

  def event_manager?(event)
    return false if current_user.nil?

    current_user.is_admin? || !!event&.is_managed_by?(current_user)
  end

  # Manager of the event or admin; owners of a registration are not enough.
  def authorize_event_manager!(event)
    raise NotAuthorized unless event_manager?(event)
  end

  def render_forbidden
    respond_to do |format|
      format.html { render 'shared/forbidden', status: :forbidden }
      format.any { head :forbidden }
    end
  end

  private

  def extract_locale_from_accept_language_header
    http_accept_language = request.env['HTTP_ACCEPT_LANGUAGE']
    return http_accept_language.scan(/^[a-z]{2}/).first if http_accept_language
    nil
  end

end
