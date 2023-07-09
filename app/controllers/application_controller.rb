class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  
  def current_user?(user)
    user && user == current_user
  end

  helper_method :current_user, :current_user?
end
