Fabricator(:document) do
  project
  name { Faker::Lorem.word }
  text { Faker::Lorem.paragraph }
  order_number 1
end
