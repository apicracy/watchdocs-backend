module SampleJsonSchemasHelpers
  def json_schema_sample
    {
      schema: 'http://json-schema.org/draft-04/schema#',
      type: 'object',
      properties: {
        types: {
          type: 'array',
          items: {
            type: 'string'
          }
        }
      },
      required: ['types']
    }
  end
end

RSpec.configure do |config|
  config.include SampleJsonSchemasHelpers
end
