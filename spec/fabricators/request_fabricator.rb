Fabricator(:request) do
  endpoint(inverse_of: :request)
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

Fabricator(:outdated_request, from: :request) do
  body_draft do
    {
      schema: 'http://json-schema.org/draft-04/schema#',
      type: 'object',
      properties: {
        numbers: {
          type: 'array',
          items: {
            type: 'integer'
          }
        }
      },
      required: ['numbers']
    }
  end
end
