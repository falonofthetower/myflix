class SessionsController < ApplicationController
  def new
    redirect_to home_path if logged_in?
  end
  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:info] = "You have logged in"
      redirect_to videos_path
    else
      flash[:danger] = "Your credentials are invalid!"
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "You are signed out!"
  end
end
