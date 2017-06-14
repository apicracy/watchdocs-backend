class ResetPassword
  attr_reader :password, :password_confirmation,
              :token, :user

  def initialize(attributes = {})
    @password = attributes[:password]
    @password_confirmation = attributes[:password_confirmation]
    @token = attributes[:token]
  end

  def call
    @user = User.reset_password_by_token(
      reset_password_token: token,
      password: password,
      password_confirmation: password_confirmation
    )
    password_changed_email if user.errors.empty?
    user
  end

  def password_changed_email
    UserPasswordMailer.changed(user.id)
                      .deliver_now
  end
end
