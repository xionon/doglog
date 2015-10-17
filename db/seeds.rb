# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create(:email => 'alec.hipshear@gmail.com', :password => 'password', :password_confirmation => 'password')
user.confirm or fail("couldn't confirm user")

sherman = user.dogs.create(name: "Sherman")
maggie = user.dogs.create(name: "Maggie")

50.times do
  sherman.posts.create(body: "Bark! " * rand(10))
end

50.times do
  maggie.posts.create(body: "Hmm. " * rand(10))
end
