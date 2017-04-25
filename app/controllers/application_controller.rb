class ApplicationController < ActionController::API
  # Needed for Cancan ControllerAdditions
  include ActionController::Helpers
  # We need to make sure all resources are authorized with CanCan
  include CanCan::ControllerAdditions
  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied, with: :record_not_found_error
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_error

  def render_resource(resource)
    if resource.errors.empty?
      render json: resource
    else
      validation_error(resource)
    end
  end

  def record_not_found_error(exception)
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
