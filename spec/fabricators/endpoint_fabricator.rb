Fabricator(:endpoint) do
  project
  http_method { Endpoint::METHODS.first }
  url { "/#{Faker::Lorem.word}/#{Faker::Lorem.word}/:id" }
  status { Endpoint.statuses[:up_to_date] }
  title { Faker::Lorem.sentence }
  summary { Faker::Lorem.paragraph }
  order_number 1
end

Fabricator(:full_endpoint, from: :endpoint) do
  responses(count: 1)
  url_params(count: 1)
end
