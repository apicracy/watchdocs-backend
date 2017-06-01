Fabricator(:project) do
  user
  name { Faker::Company.name }
  base_url { Faker::Internet.url(Faker::Internet.domain_name, '') }
  app_id { 'FAKEPROJECT' }
  app_secret { 'ov7n87c4noa89w4to9' }
end
