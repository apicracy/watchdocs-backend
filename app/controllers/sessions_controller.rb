class SessionsController < Devise::SessionsController
  respond_to :json

  def create
    ActionCable.server.broadcast 'notifications', id: 5, message: 'Hello world!'
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    yield resource if block_given?
    render json: current_user
  end

  private

  def respond_to_on_destroy
    head :no_content
  end
end
