class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    build_resource(sign_up_params)

    resource.save && SignupMailer.welcome(resource.id).deliver_now
    yield resource if block_given?
    render_resource(resource)
  end
end
