class CreateResetPasswordToken
  attr_reader :user, :public_token

  def initialize(email)
    @user = User.find_by email: email
  end

  def call
    return unless user
    create_token
    send_reset_password_instructions
  end

  private

  def create_token
    @public_token, private_token = Devise.token_generator.generate(
      user.class, :reset_password_token
    )
    user.assign_attributes(
      reset_password_token: private_token,
      reset_password_sent_at: Time.now.utc
    )
    user.save(validate: false)
  end

  def send_reset_password_instructions
    UserPasswordMailer.reset_instructions(user.id, public_token)
                      .deliver_now
  end
end
