Fabricator(:response) do
  endpoint
  http_status_code { 200 }
  status { Response.statuses['up_to_date'] }
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

Fabricator(:outdated_response, from: :response) do
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
