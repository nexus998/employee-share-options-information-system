require 'application_responder'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html, :docx

  before_action :set_locale

  def after_sign_in_path_for(_resource)
    current_user.has_role?(:admin) ? url_for(action: 'home', controller: '/pages') : participant_dashboard_path
    # '/dashboard'
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def check_role(available_role)
    if current_user.has_role? available_role
      true
    else
      flash[:alert] = 'You are not authorized to access this page.'
      redirect_to participant_error_path
    end
  end

  def default_url_options(options={})
    { locale: I18n.locale }
  end
end
