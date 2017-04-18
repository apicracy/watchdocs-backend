Fabricator(:endpoint) do
  project
  http_method { Endpoint::METHODS.first }
  url { '/contributions' }
  status { Endpoint.statuses[:up_to_date] }
  title { Faker::Lorem.sentence }
  summary { Faker::Lorem.paragraph }
end
