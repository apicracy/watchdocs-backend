Fabricator(:group) do
  project
  name { Faker::Lorem.word }
  description { Faker::Lorem.paragraph }
  order_number 1
end
