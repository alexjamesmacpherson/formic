def print_flush(str)
  print str
  $stdout.flush
end

# Seed Counts:
schools = 1 #25
students = 30 #325
parents = 10 #50
teachers = 10 #75
year_groups = 3 # per school
departments = ['Science Department', 'Maths Department', 'English Department', 'History Department'] # per school

puts "\e[0m\nSEEDING SCHOOLS:"
schools.times do
  address = Faker::Address.street_address.concat("\n" + Faker::Address.city)
  sch = School.create!(name: Faker::Educator.secondary_school,
                 address: address,
                 phone: "+44 #{rand(9999).to_s.rjust(4,'0')} #{rand(999999).to_s.rjust(6,'0')}",
                 motto: Faker::Lorem.sentence)
  print_flush("\e[0;32m.\e[0m")
  4.times do |n|
    begin
      loc = sch.locations.build(name: "#{departments[n % 2][0]}#{n + rand(1..5)}")
    end until loc.valid?
    loc.save
    print_flush("\e[0;33m.\e[0m")
  end
end

puts "\n\nSEEDING YEAR GROUPS:"
years = schools * year_groups
years.times do |n|
  YearGroup.create!(school_id: n.to_i % schools.to_i + 1,
                    name: "Year #{(n%year_groups + 10)}")
  print_flush("\e[1;49;31m.\e[0m")
end

puts "\n\nSEEDING USERS:"
# Students:
students.times do |n|
  school = rand(1..schools)
  User.create!(school_id: school,
               email: "student-#{n}@test.com",
               group: 1,
               name: Faker::Name.name,
               bio: Faker::Hacker.say_something_smart,
               year_group: YearGroup.all.where(school_id: school)[n%year_groups],
               password: 'password',
               password_confirmation: 'password',
               activated: true,
               activated_at: Time.zone.now)
  print_flush("\e[1;49;34m.\e[0m")
end
# Parents:
parents.times do |n|
  User.create!(school_id: rand(1..schools),
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
  rand(1..3).times do
    child = User.where(school_id: parent.school_id, group: 1).sample
    relation = ParentRelation.new(parent_id: parent.id,
                                  child_id: child.id)
    if relation.valid?
      relation.save
      print_flush("\e[0;35m.\e[0m")
    end
  end
end

@students = User.where(group: 1)
@students.each do |pupil|
  tutor = User.where(school_id: pupil.school_id,
                     group: 3).sample
  if tutor
    pupil.tutor = tutor
    pupil.save
  end
  print_flush("\e[0;36m.\e[0m")
end

puts "\n\nSEEDING DEPARTMENTS AND SUBJECTS:"
schools.times do |n|
  departments.each do |d|
    dept = Department.create!(school_id: n + 1,
                              name: d)
    print_flush("\e[0;35m.\e[0m")
    year_groups.times do |y|
      subject = dept.subjects.create!(name: "#{dept.name.gsub('Department', '')} #{y.to_i + 10}#{case rand(1..3) when 1 then 'X' when 2 then 'C' else 'K' end}",
                                      year_group_id: y + n + 1)
      print_flush("\e[1;49;34m.\e[0m")

      subject.teaches.create!(teacher: User.where(group: 3).sample)
      print_flush("\e[0;36m.\e[0m")

      rand(1..10).times do
        student = User.where(group: 1,
                             year_group: subject.year_group).sample
        study = subject.studies.new(pupil: student,
                                    challenge_grade: ('A'..'F').to_a.sample)
        if study.valid?
          study.save
          print_flush("\e[1;49;34m.\e[0m")
        end
      end
    end
  end
end

puts "\n\nSEEDING SCHOOL CALENDAR:"
schools.times do |n|
  Term.create!(school_id: n + 1,
               name: 'Autumn Term',
               starts: DateTime.new(2016, 9, 5),
               ends: DateTime.new(2016, 12, 16),
               halfterm_starts: DateTime.new(2016, 10, 22),
               halfterm_ends: DateTime.new(2016, 10, 30))
  print_flush("\e[1;49;36m.\e[0m")
  Term.create!(school_id: n + 1,
               name: 'Spring Term',
               starts: DateTime.new(2017, 1, 9),
               ends: DateTime.new(2017, 3, 31),
               halfterm_starts: DateTime.new(2017, 2, 18),
               halfterm_ends: DateTime.new(2017, 2, 26))
  print_flush("\e[1;49;36m.\e[0m")
  Term.create!(school_id: n + 1,
               name: 'Summer Term',
               starts: DateTime.new(2017, 4, 24),
               ends: DateTime.new(2017, 7, 7),
               halfterm_starts: DateTime.new(2017, 5, 27),
               halfterm_ends: DateTime.new(2017, 6, 4))
  print_flush("\e[1;49;36m.\e[0m")

  6.times do |t|
    Period.create!(school_id: n + 1,
                   name: "Period #{t + 1}",
                   starts: DateTime.new(2017, 3, 6, 9 + t),
                   ends: DateTime.new(2017, 6, 9 + t + 1))
    print_flush("\e[1;49;36m.\e[0m")
  end
end

puts "\n\nSEEDING LESSONS:"
Subject.all.each do |subject|
  n = 0
  Location.all.each do |location|
    n = n + 1
    term = Term.second.starts
    start = DateTime.new(term.year, term.month, term.day + rand(5), 8 + rand(8))
    begin
      if Term.first.in_term?(start) && !Term.first.in_halfterm?(start) ||
          Term.second.in_term?(start) && !Term.second.in_halfterm?(start) ||
          Term.third.in_term?(start) && !Term.third.in_halfterm?(start)
        begin
          s = subject.lessons.new(location: location, start_time: start, end_time: start + 1.hour)
          start = DateTime.new(start.year, start.month, start.day, 8 + rand(8))
        end until s.valid?
        s.save
        print_flush("\e[1;49;3#{n}m.\e[0m")
      end
      start = start + 1.week
    end while start < Term.second.ends
  end
end

puts "\n\nSEEDING ASSIGNMENTS:"
Subject.all.each do |subject|
  rand(1..10).times do |a|
    assignment = subject.assignments.create(name: "Assignment #{a.to_i + 1}",
                                            information: Faker::Lorem.paragraph,
                                            due: subject.lessons.sample.start_time + rand(1..3).weeks + 1.minute)
    print_flush("\e[0;32m.\e[0m")

    if assignment.due < Time.zone.now
      subject.pupils.each do |pupil|
        submission = pupil.submissions.create!(assignment: assignment,
                                               file: File.open(File.join(Rails.root, '/public/images/fallback/default.png')),
                                               marker: assignment.subject.teachers.first,
                                               marked: true,
                                               marked_at: assignment.due,
                                               feedback: Faker::Lorem.sentence,
                                               grade: rand(-2..2))
        print_flush("\e[0;36m.\e[0m")
      end
    end
  end
end

puts "\n\nSEEDING MESSAGES AND NOTIFICATIONS:"
emails = ['student', 'teacher', 'admin']
emails.each do |email|
  user = User.where(email: "#{email}-0@test.com").first
=begin
  3.times do
    assignment = user.studies.first.assignments.sample
    user.notifications.create!(title: "You've been set a new a new assignment", message: assignment.name, link: "/assignments/#{assignment.id}")
  end
=end
  messages = ["Hey, #{user.name.split[0]}!", 'Hello', 'Hey, I have a question, do you mind answering it for me?']
  2.times do
    other_user = User.all.sample

    chat = Chat.new(name: 'Test Conversation')
    chat.converses.new(user: user)
    chat.converses.new(user: other_user)
    chat.save
    chat.messages.create(sender: other_user, text: messages.sample)
  end
end

puts "\n\nSEEDING COMPLETED SUCCESSFULLY!\n"