class ProcessExternalEndpointSchemas
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
    @group = find_or_create_group(@project, @endpoint_data[:url])
  end

  def call
    update_response
    return unless request_data
    update_url_params
    update_request
  end

  private

  def update_response
    @response = endpoint.update_response_for_status(
      response_data[:status],
      body: response_data[:body],
      headers: parse_headers(response_data[:headers])
    )
  end

  # TODO: Create card for changes in gem: filter query params and support types
  def update_url_params
    params = UrlParamsSchema.new(request_data[:url_params]).params
    params.each { |name, required| create_or_update_url_param(name, required) }
  end

  def update_request
    endpoint.update_request(
      body: request_data[:body],
      headers: parse_headers(request_data[:headers])
    )
  end

  ## Helpers:

  def find_project(app_id)
    Project.find_by!(app_id: app_id)
  rescue ActiveRecord::RecordNotFound => e
    raise ProjectNotFound, e.message
  end

  def endpoint
    @endpoint ||= project.endpoints.find_or_initialize_by(
      url: endpoint_data[:url],
      http_method: endpoint_data[:method],
      group_id: @group
    )
    @endpoint.up_to_date! unless @endpoint.status
    @endpoint
  end

  def create_or_update_url_param(name, required)
    endpoint.url_params
            .find_or_initialize_by(name: name)
            .update_required(required)
  end

  def parse_headers(headers)
    headers['properties'].map do |header, _v|
      [header, headers['required'].include?(header)]
    end.to_h
  end

  def find_or_create_group(project, name)
    Group.find_or_create_by!(project: project, name: parse_name(name))
  end

  def parse_name(url)
    url.split('/v1/').last.split('/').first.humanize
  end
end
