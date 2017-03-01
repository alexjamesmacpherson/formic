def print_flush(str)
  print str
  $stdout.flush
end

# Seed Counts:
schools = 5 #25
students = 50 #325
parents = 10 #50
teachers = 10 #75
year_groups = 2 # per school

puts "\e[0m\nSEEDING SCHOOLS:"
schools.times do
  address = Faker::Address.street_address.concat("\n" + Faker::Address.city)
  School.create!(name: Faker::Educator.secondary_school,
                 address: address,
                 phone: "+44 #{rand(9999).to_s.rjust(4,'0')} #{rand(999999).to_s.rjust(6,'0')}",
                 motto: Faker::Lorem.sentence)
  print_flush("\e[0;32m.\e[0m")
end

puts "\n\nSEEDING YEAR GROUPS:"
years = schools * year_groups
years.times do |n|
  YearGroup.create!(school_id: n.to_i % schools.to_i + 1,
                    name: "Year #{(n%2 + 10)}")
  print_flush("\e[1;49;31m.\e[0m")
end

puts "\n\nSEEDING USERS:"
# Students:
students.times do |n|
  school = rand(1...schools)
  User.create!(school_id: school,
               email: "student-#{n}@test.com",
               group: 1,
               name: Faker::Name.name,
               bio: Faker::Hacker.say_something_smart,
               year_group: YearGroup.all.where(school_id: school)[n%2],
               password: 'password',
               password_confirmation: 'password',
               activated: true,
               activated_at: Time.zone.now)
  print_flush("\e[1;49;34m.\e[0m")
end
# Parents:
parents.times do |n|
  User.create!(school_id: rand(1...schools),
               email: "parent-#{n}@test.com",
               group: 2,
               name: Faker::Name.name,
               bio: Faker::Company.catch_phrase,
               password: 'password',
               password_confirmation: 'password',
               activated: true,
               activated_at: Time.zone.now)
  print_flush("\e[0;35m.\e[0m")
end
# Teachers:
teachers.times do |n|
  User.create!(school_id: n.to_i % schools.to_i + 1,
               email: "teacher-#{n}@test.com",
               group: 3,
               name: Faker::Name.name,
               bio: Faker::Lorem.paragraph,
               password: 'password',
               password_confirmation: 'password',
               activated: true,
               activated_at: Time.zone.now)
  print_flush("\e[0;36m.\e[0m")
end
# Admin Staff:
5.times do |n|
  User.create!(school_id: n.to_i % schools.to_i + 1,
               email: "admin-#{n}@test.com",
               group: 4,
               name: Faker::Name.name,
               bio: Faker::Lorem.paragraph,
               password: 'password',
               password_confirmation: 'password',
               activated: true,
               activated_at: Time.zone.now)
  print_flush("\e[0;33m.\e[0m")
end

puts "\n\nSEEDING RELATIONS:"
@parents = User.where(group: 2)
@parents.each do |parent|
  child = User.where(school_id: parent.school_id, group: 1).sample
  if child
    Parent.create(parent_id: parent.id, child_id: child.id)
  end
  print_flush("\e[0;35m.\e[0m")
end
@students = User.where(group: 1)
@students.each do |pupil|
  tutor = User.where(school_id: pupil.school_id, group: 3).sample
  if tutor
    Tutor.create(tutor_id: tutor.id, pupil_id: pupil.id)
  end
  print_flush("\e[0;36m.\e[0m")
end

puts "\n\nSEEDING COMPLETED SUCCESSFULLY!\n"