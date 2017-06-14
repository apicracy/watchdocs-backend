class SignupMailer < ApplicationMailer
  def welcome(user_id)
    @user = User.find(user_id)
    mail to: @user.email, subject: 'Thanks for joining Watchdocs'
  end
end
