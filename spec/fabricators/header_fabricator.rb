Fabricator(:header) do
  key { Faker::Lorem.word }
  required { true }
  description { Faker::Lorem.sentence }
  status { 0 }
end

Fabricator(:request_header) do
  headerable(fabricator: :request)
end

Fabricator(:response_header) do
  headerable(fabricator: :response)
end
