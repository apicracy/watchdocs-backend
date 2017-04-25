Fabricator(:url_param) do
  endpoint
  name { Faker::Lorem.word }
  required { true }
  is_part_of_url { false }
end
