class UpdateEndpointSchemas
  attr_reader :project,
              :request_data,
              :response_data,
              :endpoint_data,
              :response

  # TODO: Add json schema validation for params
  def initialize(endpoint_schema_params)
    @project = find_project(endpoint_schema_params[:app_id])
    @endpoint_data = endpoint_schema_params[:endpoint]
    @request_data = endpoint_schema_params[:request]
    @response_data = endpoint_schema_params[:response]
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
    UpdateResponseSchema.new(endpoint: endpoint,
                             status: response_data[:status],
                             body: response_data[:body]).call
  end

  def update_request
    UpdateRequestSchema.new(endpoint: endpoint,
                            body: request_data[:body]).call
  end

  def update_url_params
    UpdateUrlParamsFromSchema.new(endpoint: endpoint, schema: request_data[:url_params]).call
  end

  def update_endpoint_status
    new_status =  if endpoint.responses.any?(&:outdated?) ||
                     endpoint.request.outdated? ||
                     endpoint.url_params.any?(&:outdated?)
                    :outdated
                  else
                    :up_to_date
                  end
    endpoint.update(status: new_status)
  end

  ## Helpers:

  def find_project(app_id)
    Project.find_by!(app_id: app_id)
  rescue ActiveRecord::RecordNotFound => exception
    raise ProjectNotFound, exception.message
  end

  def endpoint
    endpoint ||= project.endpoints.find_or_initialize_by(
      url: endpoint_data[:url],
      http_method: endpoint_data[:method]
    )
    endpoint.up_to_date! unless endpoint.status
    endpoint
  end
end
