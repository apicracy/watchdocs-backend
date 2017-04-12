class ApplicationController < ActionController::API
  # Needed for Cancan ControllerAdditions
  include ActionController::Helpers
  # We need to make sure all resources are authorized with CanCan
  include CanCan::ControllerAdditions
  check_authorization

  def record_not_found(e)
    render json: {
      errors: [
        { status: '404', title: 'Record not found',
          detail: e.message, code: '104' }
      ]
    }, status: :not_found
  end

  private

  def current_user
    User.first
  end
end
