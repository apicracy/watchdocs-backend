Fabricator(:group) do
  name { Faker::Lorem.word }
  description { Faker::Lorem.paragraph }
end
