def print_flush(str)
  print str
  $stdout.flush
end

# Seed Counts:
schools = 25
students = 325
parents = 50
teachers = 75

puts "\e[0m\nSEEDING SCHOOLS:"
schools.times do
  address = Faker::Address.street_address.concat(Faker::Address.city)
  School.create!(name: Faker::Educator.secondary_school,
                 address: address,
                 phone_number: "+44 #{rand(9999).to_s.rjust(4,'0')} #{rand(999999).to_s.rjust(6,'0')}",
                 motto: Faker::Lorem.sentence)
  print_flush("\e[0;32m.\e[0m")
end

puts "\n\nSEEDING USERS:"
# Students:
students.times do |n|
  address = Faker::Address.street_address.concat(Faker::Address.city)
  User.create!(school_id: rand(1...schools),
               email: "student-#{n}@test.com",
               user_group: 1,
               name: Faker::Name.name,
               address: address,
               bio: Faker::Hacker.say_something_smart,
               password: 'password',
               password_confirmation: 'password',
               activated: true,
               activated_at: Time.zone.now)
  print_flush("\e[0;34m.\e[0m")
end
# Parents:
parents.times do |n|
  address = Faker::Address.street_address.concat(Faker::Address.city)
  User.create!(school_id: rand(1...schools),
               email: "parent-#{n}@test.com",
               user_group: 2,
               name: Faker::Name.name,
               address: address,
               bio: Faker::Company.catch_phrase,
               password: 'password',
               password_confirmation: 'password',
               activated: true,
               activated_at: Time.zone.now)
  print_flush("\e[0;35m.\e[0m")
end
# Teachers:
teachers.times do |n|
  address = Faker::Address.street_address.concat(Faker::Address.city)
  User.create!(school_id: n.to_i % schools.to_i + 1,
               email: "teacher-#{n}@test.com",
               user_group: 3,
               name: Faker::Name.name,
               address: address,
               bio: Faker::Lorem.paragraph,
               password: 'password',
               password_confirmation: 'password',
               activated: true,
               activated_at: Time.zone.now)
  print_flush("\e[0;36m.\e[0m")
end
# Admin Staff:
5.times do |n|
  address = Faker::Address.street_address.concat(Faker::Address.city)
  User.create!(school_id: n.to_i % schools.to_i + 1,
               email: "admin-#{n}@test.com",
               user_group: 4,
               name: Faker::Name.name,
               address: address,
               bio: Faker::Lorem.paragraph,
               password: 'password',
               password_confirmation: 'password',
               activated: true,
               activated_at: Time.zone.now)
  print_flush("\e[0;33m.\e[0m")
end

puts "\n\nSEEDING RELATIONS:"
@parents = User.where(user_group: 2)
@parents.each do |parent|
  child = User.where(school_id: parent.school_id, user_group: 1).sample
  if child
    Parent.create(parent_id: parent.id, child_id: child.id)
  end
  print_flush("\e[0;35m.\e[0m")
end
@students = User.where(user_group: 1)
@students.each do |pupil|
  tutor = User.where(school_id: pupil.school_id, user_group: 3).sample
  if tutor
    Tutor.create(tutor_id: tutor.id, pupil_id: pupil.id)
  end
  print_flush("\e[0;36m.\e[0m")
end

puts "\n\nSEEDING COMPLETED SUCCESSFULLY!\n"