class ApplicationController < ActionController::API
  # Needed for Cancan ControllerAdditions
  include ActionController::Helpers
  # We need to make sure all resources are authorized with CanCan
  include CanCan::ControllerAdditions
  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    record_not_found(exception)
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    record_not_found(exception)
  end

  def record_not_found(exception)
    render json: {
      errors: [
        {
          status: '404',
          title: 'Record not found',
          detail: exception.message,
          code: '104'
        }
      ]
    }, status: :not_found
  end

  def validation_error(resource)
    render json: {
      errors: [
        {
          status: '400',
          title: 'Bad Request',
          detail: resource.errors,
          code: '100'
        }
      ]
    }, status: :bad_request
  end
end
