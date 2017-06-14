class ResetPassword
  attr_reader :password, :password_confirmation, :token

  def initialize(attributes = {})
    @password = attributes[:password]
    @password_confirmation = attributes[:password_confirmation]
    @token = attributes[:token]
  end

  def call
    User.reset_password_by_token(
      reset_password_token: token,
      password: password,
      password_confirmation: password_confirmation
    )
  end
end
