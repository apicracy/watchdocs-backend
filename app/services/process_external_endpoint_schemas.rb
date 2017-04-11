class ProjectNotFound < StandardError; end

class ProcessExternalEndpointSchemas
  attr_reader :project,
              :schemas,
              :endpoint_data,
              :response

  # TODO: Add json schema validation for params
  def initialize(endpoint_schema_params)
    @project = Project.find(endpoint_schema_params[:project_id])
    @endpoint_data = endpoint_schema_params[:endpoint]
    @schemas = {
      request: endpoint_schema_params[:request],
      response: endpoint_schema_params[:response]
    }
  rescue ActiveRecord::RecordNotFound
    raise ProjectNotFound
  end

  def call
    update_response
    return unless @schemas[:request]
    update_url_params
    update_request
  end

  private

  def update_response
    @response = endpoint.update_response(
      schemas[:response][:status],
      schemas[:response][:body],
      parse_headers(schemas[:response][:headers])
    )
  end

  # TODO: Create card for changes in gem: filter query params and support types
  def update_url_params
    params = ParseUrlParamsSchema.new(schemas[:request][:url_params]).call
    params.each { |key, required| create_or_update_url_param(key, required) }
  end

  def update_request
    endpoint.update_request(
      schemas[:request][:body],
      parse_headers(schemas[:request][:headers])
    )
  end

  ## Helpers:

  def endpoint
    @endpoint ||= project.endpoints.find_or_create_by(endpoint_data)
  end

  def create_or_update_url_param(key, required)
    endpoint.url_params
            .find_or_initialize_by(key: key)
            .update_required(required)
  end

  def parse_headers(headers)
    headers['properties'].map do |header, _v|
      [header, headers['required'].include?(header)]
    end.to_h
  end
end
