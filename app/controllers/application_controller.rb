class ApplicationController < ActionController::API
  # Needed for Cancan ControllerAdditions
  include ActionController::Helpers
  # We need to make sure all resources are authorized with CanCan
  include CanCan::ControllerAdditions
  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do
    head :forbidden, content_type: 'text/html'
  end

  def record_not_found(e)
    render json: {
      errors: [
        { status: '404', title: 'Record not found',
          detail: e.message, code: '104' }
      ]
    }, status: :not_found
  end


end
