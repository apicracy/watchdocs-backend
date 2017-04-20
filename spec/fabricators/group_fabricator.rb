Fabricator(:group) do
  project
  name { Faker::Lorem.word }
  description { Faker::Lorem.paragraph }
end
