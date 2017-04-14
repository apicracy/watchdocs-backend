Fabricator(:endpoint) do
  project
  request_method { Endpoint::METHODS.first }
  url { '/contributions' }
  status { 0 }
  title { Faker::Lorem.sentence }
  summary { Faker::Lorem.paragraph }
end
