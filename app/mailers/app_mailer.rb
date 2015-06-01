class AppMailer < ActionMailer::Base
  def welcome(user)
    @user = user
    mail from: 'peter.karth.email@gmail.com', to: user.email, subject: "You are now a member of the MyFlix Family!"
  end
end
