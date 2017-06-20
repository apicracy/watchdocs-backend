class UserPasswordMailer < ApplicationMailer
  def reset_instructions(user_id, token)
    @user = User.find(user_id)
    @token = token
    mail to: @user.email, subject: 'Reset password instructions'
  end

  def changed(user_id)
    @user = User.find(user_id)
    mail to: @user.email, subject: 'Password changed'
  end
end
