Fabricator(:request) do
  endpoint
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
end
