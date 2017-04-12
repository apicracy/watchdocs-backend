Fabricator(:user) do
  email { Faker::Internet.email }
  password { 'admin123' }
end
