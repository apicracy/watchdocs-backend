Fabricator(:header) do
  key { Faker::Lorem.word }
  required { true }
  description { Faker::Lorem.sentence }
  status { 0 }
end

Fabricator(:request_header, from: :header) do
  headerable(fabricator: :request)
end

Fabricator(:response_header, from: :header) do
  headerable(fabricator: :response)
end
