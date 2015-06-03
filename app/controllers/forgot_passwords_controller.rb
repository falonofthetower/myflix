class ForgotPasswordsController < ApplicationController
  def new
  end

  def create
    user = User.where(email: params[:email]).first

    if user
      redirect_to forgot_password_confirmation_path
      user.tokenize
      user.save
      AppMailer.send_forgot_password(user).deliver
    else
      flash[:danger] = "There is no account with that email"
      redirect_to forgot_password_path
    end
  end

  def show
  end
end
