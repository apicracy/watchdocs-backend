Fabricator(:project) do
  user
  name { Faker::Company.name }
end
