Fabricator(:document) do
  project
  name { Faker::Lorem.word }
  text { Faker::Lorem.paragraph }
end
