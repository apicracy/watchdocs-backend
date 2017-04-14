Fabricator(:url_param) do
  endpoint
  key { Faker::Lorem.word }
  required { true }
  is_part_of_url { false }
end
