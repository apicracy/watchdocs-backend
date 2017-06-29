class SignupMailer < ApplicationMailer
  SUPPORT_MAIL = 'k.szromek@watchdocs.io'

  def welcome(user_id)
    @user = User.find(user_id)
    mail from: SUPPORT_MAIL, to: @user.email, subject: 'Thanks for joining Watchdocs'
  end
end
