class PasswordResetsController < ApplicationController
  def show
    user = User.where(token: params[:id]).first
    if user
      @token = user.token 
    else
      redirect_to expired_token_path
    end
  end

  def create
    user = User.where(token: params[:token]).first
    user.password = params[:password]
    if user.save
      user.destroy_token
      flash[:success] = "Password Changed!"
      redirect_to sign_in_path
    else
      flash[:danger] = "Your password isn't valid"
      redirect_to password_reset_path(params[:token])
    end
  end
end
