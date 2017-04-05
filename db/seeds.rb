# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create(email: 'joe@doe.com')

Project.create(
  user: user,
  name: 'Project',
  base_url: 'https://api.project.com/',
  api_key: 'ASW4vohno48c7arhw4coraw4hjroaw3va',
  api_secret: 'Safuifa9w83fnw83nwefniusdjfajsdfa'
)
