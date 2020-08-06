# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
30.times do
  User.create(name: Faker::Name.first_name,
               email: Faker::Internet.email,
               password: "password",
               password_confirmation: "password",
               department: ["管理","事業推進","事業企画"].sample,
               team: ["医療","セールス","開発","マーケティング"].sample,
               office: ["東京","名古屋"].sample,
                 )
end
