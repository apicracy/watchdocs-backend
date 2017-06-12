class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    user = CreateUser.new(sign_up_params).call
    render_resource(user)
  end
end
