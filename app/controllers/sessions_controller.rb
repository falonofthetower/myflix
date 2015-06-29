class SessionsController < ApplicationController
  def new
    redirect_to home_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      if user.active
        session[:user_id] = user.id
        flash[:success] = "You have logged in"
        redirect_to home_path
      else
        flash[:danger] =
          "Your account has been suspended, please contact customer support"
        redirect_to sign_in_path
      end
    else
      flash[:danger] = "Your credentials are invalid!"
      redirect_to sign_in_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "You are signed out!"
  end
end
