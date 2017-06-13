class CreateUser
  attr_reader :user

  def initialize(initial_params)
    @user = User.new(initial_params)
  end

  def call
    return user unless user.save
    track
    send_welcome_email
    user
  end

  private

  def send_welcome_email
    SignupMailer.welcome(user.id).deliver_now
  end

  def track
    ActiveCampaignTracking.for(user.email)
                          .add_to_contacts
  end
end
