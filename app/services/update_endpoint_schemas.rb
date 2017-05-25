class UpdateEndpointSchemas
  attr_reader :project,
              :request_data,
              :response_data,
              :endpoint_data,
              :endpoint

  # TODO: Add json schema validation for params
  def initialize(endpoint_schema_params)
    @project = find_project(endpoint_schema_params[:app_id])
    @endpoint_data = endpoint_schema_params[:endpoint]
    @request_data = endpoint_schema_params[:request]
    @response_data = endpoint_schema_params[:response]
    @endpoint = project.endpoints.find_or_create_by!(
      url: endpoint_data[:url],
      http_method: endpoint_data[:method]
    )
  end

  def call
    update_response
    if request_data
      update_url_params
      update_request
    end
    update_endpoint_status
  end

  private

  def update_response
    response = endpoint.responses
                       .find_or_initialize_by(http_status_code: response_data[:status])

    UpdateResponseSchema.new(response: response,
                             body: response_data[:body]).call
  end

  def update_request
    UpdateRequestSchema.new(request: endpoint.request,
                            body: request_data[:body]).call
  end

  def update_url_params
    UpdateUrlParamsFromSchema.new(endpoint: endpoint,
                                  schema: request_data[:url_params]).call
  end

  def update_endpoint_status
    endpoint.save! # This needs to blows up when endpoint can not be saved
    # TODO: Record an event when status change:
    # ... if endpoint.status_changed?
  end

  def find_project(app_id)
    Project.find_by!(app_id: app_id)
  rescue ActiveRecord::RecordNotFound => exception
    raise ProjectNotFound, exception.message
  end
end
