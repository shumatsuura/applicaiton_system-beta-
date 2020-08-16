# 30.times do
#   user = User.create(name: Faker::Name.first_name,
#                email: Faker::Internet.email,
#                password: "password",
#                password_confirmation: "password",
#                department: ["管理","事業推進","事業企画"].sample,
#                team: ["医療","セールス","開発","マーケティング"].sample,
#                office: ["東京","名古屋"].sample,
#                  )
# end
30.times do
  a = User.find_by(id: User.ids.sample(1)).pre_applications.create(
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
      amount: (3000..1000000).to_a.sample,)
  a.approvals.create(user_id: User.ids.sample(1).first)
  a.create_overall_approval
end
