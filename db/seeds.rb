# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def user(email, password='password')
  User.create!(
    :email => email,
    :password => password,
    :password_confirmation => password,
  ).tap { |u| u.confirm or fail("couldn't confirm #{email}") }
end

alec = user('alec.hipshear@gmail.com')
nora = user('norajaneart@gmail.com')
janie = user('hipshear@gmail.com')

dogs = [
  alec.dogs.create(name: "Sherman"),
  alec.dogs.create(name: "Maggie"),
  nora.dogs.create(name: 'Egypt'),
  janie.dogs.create(name: 'Gypsy')
]

words = [
  'Woof! ',
  'Hmmm. ',
  'Meow? ',
  'Aouuu! '
]

dogs = dogs.zip(words)

100.times do
  dog = dogs.sample
  dog[0].posts.create(body: dog[1] + (dog[1] * rand(10)))
end
