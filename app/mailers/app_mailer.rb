class AppMailer < ActionMailer::Base
  def welcome(user)
    @user = user
    mail from: 'info@myflix.com', to: user.email, subject: "You are now a member of the MyFlix Family!"
  end

  def send_forgot_password(user)
    @user = user
    mail from: 'info@myflix.com', to: user.email, subject: "Please reset your password"
  end
end
