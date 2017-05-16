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
      UpdateUrlParamFromSchema.new(endpoint: endpoint, name: name, required: required).call
    end
  end

  private

  def discovered_params
    UrlParamsSchema.new(schema).params
  end
end
