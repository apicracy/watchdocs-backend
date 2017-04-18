Fabricator(:endpoint) do
  project
  request_method { Endpoint::METHODS.first }
  url { '/contributions' }
  status { Endpoint.statuses[:fresh] }
  title { Faker::Lorem.sentence }
  summary { Faker::Lorem.paragraph }
end
