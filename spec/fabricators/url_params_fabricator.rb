Fabricator(:url_param) do
  endpoint
  name { Faker::Lorem.word }
  required { true }
  is_part_of_url { false }
end

Fabricator(:outdated_url_param, from: :url_param) do
  required_draft { false }
end
