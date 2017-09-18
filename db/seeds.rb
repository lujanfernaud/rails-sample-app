# Users.
User.create!(name:  "Admin",
             email: "admin@example.com",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

101.times do |n|
  puts "Creating user #{n + 1}/101..."

  name  = Faker::Name.name
  email = "example-#{n + 1}@railstutorial.org"

  User.create!(name:  name,
               email: email,
               password:              "password",
               password_confirmation: "password",
               activated: true,
               activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)

# Microposts.
50.times do |n|
  puts "Creating micropost #{n + 1}/50..."

  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create(content: content) }
end

# Following relationships.
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]

following.each do |followed|
  puts "Populating first user's followings..."

  user.follow(followed)
end

followers.each do |follower|
  puts "Populating first user's followers..."

  follower.follow(user)
end
