Fabricator(:request) do
  endpoint(inverse_of: :endpoint)
  status { Request.statuses[:up_to_date] }
  body do
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
  headers(count: 1, inverse_of: :headerable)
end
