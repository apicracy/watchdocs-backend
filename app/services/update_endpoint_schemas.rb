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
    add_group
    update_response
    return unless request_data
    update_url_params
    update_request
  end

  private

  def update_response
    response = endpoint.responses
                       .find_or_initialize_by(http_status_code: response_data[:status])
    new_body = response_data[:body]

    response.update(body_draft: new_body)
  end

  def update_request
    request = endpoint.request
    new_body = request_data[:body]

    request.update(body_draft: new_body)
  end

  def update_url_params
    discovered_params.each do |name, required|
      url_param = endpoint.url_params.find_or_initialize_by(name: name)

      if url_param.required.present? && required != url_param.required
        url_param.update(required_draft: required)
      else
        url_param.update(required: required)
      end
    end
  end

  def add_group
    return if @endpoint.group.present?
    @group = @project.groups.find_or_create_by!(
      name: CreateGroupName.new(url: endpoint_data[:url]).parse_url,
      group_id: nil
    )
    @endpoint.update(group: @group)
  end

  def discovered_params
    UrlParamsSchema.new(request_data[:url_params]).params
  end

  def find_project(app_id)
    Project.find_by!(app_id: app_id)
  rescue ActiveRecord::RecordNotFound => exception
    raise ProjectNotFound, exception.message
  end
end
