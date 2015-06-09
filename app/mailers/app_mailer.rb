class AppMailer < ActionMailer::Base
  default from: "info@peter-myflix.herokuapp.com"

  def welcome(user)
    @user = user
    mail to: user.email, subject: "You are now a member of the MyFlix Family!"
  end

  def send_forgot_password(user)
    @user = user
    mail to: user.email, subject: "Please reset your password"
  end

  def send_invitation(invitation)
    @invitation = invitation
    mail to: invitation.recipient_email, subject: "Inivitation to join MyFlix"
  end
end
