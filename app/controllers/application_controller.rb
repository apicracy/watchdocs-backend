class ApplicationController < ActionController::API
  def record_not_found(e)
    render json: {
      errors: [
        { status: '404', title: 'Record not found',
          detail: e.message, code: '104' }
      ]
    }, status: :not_found
  end
end
