class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception
  helper :all
  # before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    root_path
  end
  
  def current_ability
    @current_ability ||= Ability.new(current_user)
  end
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
  end

  def after_sign_in_path_for(resource)
    root_path
  end

  private

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
