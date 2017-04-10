Fabricator(:user) do
  email { Faker::Internet.email }
end
