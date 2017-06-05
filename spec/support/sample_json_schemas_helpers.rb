module SampleJsonSchemasHelpers
  def json_schema_sample(items_in_array: 'string')
    {
      'schema': 'http://json-schema.org/draft-04/schema#',
      'type': 'object',
      'properties': {
        'types': {
          'type': 'array',
          'items': {
            'type': items_in_array
          }
        }
      },
      'required': ['types']
    }.deep_stringify_keys
  end
end

RSpec.configure do |config|
  config.include SampleJsonSchemasHelpers
end
