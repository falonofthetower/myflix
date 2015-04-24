class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||=  User.find(session[:user_id]) if session[:user_id]
  end
  
  def logged_in?
    !!current_user
  end

  def access_denied
    flash[:error] = "You don't have the access to do that!"
    redirect_to sign_in_path
  end

  def require_user
    access_denied unless logged_in?
  end
end
