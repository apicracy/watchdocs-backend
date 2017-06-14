class SignupMailerPreview < ActionMailer::Preview
  def welcome
    user = User.first
    SignupMailer.welcome user.id
  end
end
