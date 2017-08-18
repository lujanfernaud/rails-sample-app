User.create!(name:  "Admin",
             email: "admin@example.com",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true)

101.times do |n|
  name  = Faker::Name.name
  email = "example-#{n + 1}@railstutorial.org"

  User.create!(name:  name,
               email: email,
               password:              "password",
               password_confirmation: "password")
end
