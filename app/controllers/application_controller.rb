class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Allow extra parameters for Devise if needed
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  # Redirect after sign in
  def after_sign_in_path_for(resource)
    if resource.admin?
      products_path  # redirect admins to products page
    else
      pages_home_path  # redirect normal users to home
    end
  end
end
