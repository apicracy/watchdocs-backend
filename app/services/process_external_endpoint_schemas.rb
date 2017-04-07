class ProjectNotFound < StandardError; end

class ProcessExternalEndpointSchemas
  attr_reader :project,
              :schemas,
              :endpoint_data

  # TODO: Change format of data in sinatra app
  # TODO: Add json schema validation for params
  def initialize(endpoint_schema_params)
    @project = Project.find(endpoint_schema_params[:project_id])
    @endpoint_data = {
      url: endpoint_schema_params[:endpoint],
      method: endpoint_schema_params[:method]
    }
    @schemas = {
      request: {
        body: endpoint_schema_params[:request],
        headers: endpoint_schema_params[:request_headers],
        url_params: endpoint_schema_params[:query_string_params]
      },
      response: {
        body: endpoint_schema_params[:request],
        headers: endpoint_schema_params[:response_headers],
        status: endpoint_schema_params[:status]
      }
    }
  rescue ActiveRecord::RecordNotFound
    raise ProjectNotFound
  end

  def call
    update_url_params
    create_or_update_request
    create_or_update_response
    update_headers
  end

  private

  # TODO: Create card for changes in gem: filter query params and support types
  def update_url_params
    url_params = schemas[:request][:url_params]
    url_params['properties'].each do |param, schema|
      if schema['type'] == 'object'
        children = dig_into_url_param_hash(schema)
        children.each do |child|
          key, required = build_url_param(param, child)
          create_or_update_url_param(key, required)
        end
      else
        create_or_update_url_param(
          param,
          url_params['required'].include?(param)
        )
      end
    end
  end

  def create_or_update_request
    if endpoint.request
      endpoint.request.update(body_draft: schemas[:request][:body])
    else
      endpoint.create_request(body: schemas[:request][:body])
    end
  end

  def create_or_update_response
    if response.body.present?
      response.update(body_draft: schemas[:response][:body])
    else
      response.update(body: schemas[:response][:body])
    end
  end

  def update_headers
    create_or_update_headers(endpoint.request, schemas[:request][:headers])
    create_or_update_headers(response, schemas[:response][:headers])
  end

  def endpoint
    @endpoint ||= project.endpoints.find_or_create_by(endpoint_data)
  end

  def response
    @response ||= endpoint.responses.find_or_initialize_by(
      status: schemas[:response][:status]
    )
  end

  def dig_into_url_param_hash(param_hash)
    params = []
    param_hash['properties'].each do |param, schema|
      if schema['type'] == 'object'
        children = dig_into_url_param_hash(schema)
        children.each { |c| params << [param, c] }
      else
        params << [param, param_hash['required'].include?(param)]
      end
    end
    params
  end

  def build_url_param(root, children)
    param = root
    children.flatten!
    required = children.pop # last element says if param is required
    children.each { |c| param += "[#{c}]" }
    [param, required]
  end

  def create_or_update_url_param(key, required)
    param = endpoint.url_params.find_or_initialize_by(key: key)
    if param.required.present?
      param.update(required_draft: required)
    else
      param.update(required: required)
    end
  end

  def create_or_update_headers(object, headers)
    headers['properties'].each do |k, _v|
      header = object.headers.find_or_create_by(key: k)
      required = headers['required'].include?(k)
      if header.required.present?
        header.update(required_draft: required)
      else
        header.update(required: required)
      end
    end
  end
end
