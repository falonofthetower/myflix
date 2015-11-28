class AppMailer < ActionMailer::Base
  default from: "info@peter-myflix.herokuapp.com"

  def welcome(user_id)
    @user = User.find(user_id)
    mail to: @user.email, subject: "You are now a member of the MyFlix Family!"
  end

  def send_forgot_password(user_id)
    @user = User.find(user_id)
    mail to: @user.email, subject: "Please reset your password"
  end

  def send_invitation(invitation_id)
    @invitation = Invitation.find(invitation_id)
    mail to: @invitation.recipient_email, subject: "Inivitation to join MyFlix"
  end
end
