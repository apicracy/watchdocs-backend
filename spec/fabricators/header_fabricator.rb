Fabricator(:header) do
  key { Faker::Lorem.word }
  required { true }
  description { Faker::Lorem.sentence }
end

Fabricator(:request_header, from: :header) do
  headerable { Fabricate(:request) }
end

Fabricator(:response_header, from: :header) do
  headerable { Fabricate(:response) }
end
