class UserPasswordMailerPreview < ActionMailer::Preview
  def reset_instructions
    user = User.first
    token = '8c7w4ba98nd73wxr8oa3nx3ha'
    UserPasswordMailer.reset_instructions(user.id, token)
  end
end
