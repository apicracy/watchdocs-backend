# This service updates response for given endpoint with recorded schema
class UpdateUrlParamsFromSchema
  attr_reader :endpoint, :schema

  # TODO: Create card for changes in gem: filter query params and support types
  def initialize(endpoint:, schema:)
    @endpoint = endpoint
    @schema = schema
  end

  def call
    discovered_params.each do |name, required|
      create_or_update_url_param(name, required)
    end
  end

  private

  def discovered_params
    UrlParamsSchema.new(schema).params
  end

  def create_or_update_url_param(name, required)
    param = endpoint.url_params.find_or_initialize_by(name: name)
    return if param.required == required

    if param.required
      param.update(required_draft: required)
    else
      param.update(required: required)
    end
  end
end
