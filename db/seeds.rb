# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

30.times do
  user = User.create(name: Faker::Name.first_name,
               email: Faker::Internet.email,
               password: "password",
               password_confirmation: "password",
               department: ["管理","事業推進","事業企画"].sample,
               team: ["医療","セールス","開発","マーケティング"].sample,
               office: ["東京","名古屋"].sample,
                 )
   3.times do
     a = user.pre_applications.create(
      genre:["基本","契約","財務","人事"].sample,
      item:[
      "押印（社長印）",
      "経費（50万円以上）",
      "経費（10万円以上50万円未満）",
      "経費（10万円未満）",
      "重要な契約",
      "プロジェクト予算事前申請",
      "プロジェクト予算執行",
    ].sample,
      description: Faker::Lorem.sentence,
      amount: (3000..1000000).to_a.sample,
     )
   end
end

pre_applications = PreApplication.all.sample(30)

pre_applications.each do |pre_application|
  pre_application.approvals.create(user_id: rand(1..30))
end
