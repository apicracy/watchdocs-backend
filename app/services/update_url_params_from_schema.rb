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
      url_param = endpoint.url_params.find_or_initialize_by(name: name)
      UpdateUrlParamFromSchema.new(url_param: url_param, required: required).call
    end
  end

  private

  def discovered_params
    UrlParamsSchema.new(schema).params
  end
end
