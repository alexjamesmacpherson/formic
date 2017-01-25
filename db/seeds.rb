# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
@school = School.create!(name: 'Example School', address: 'Example Street, EX4M PL3', phone_number: '+44 1919 191919', motto: 'Example!')

@child = User.create!(school_id: @school.id, email: 'student@test.com', user_group: 1, name: 'Student Test', address: 'Teston, T35T T0N')
@parent = User.create!(school_id: @school.id, email: 'parent@test.com', user_group: 2, name: 'Parent Test', address: 'Teston, T35T T0N')
@tutor = User.create!(school_id: @school.id, email: 'tutor@test.com', user_group: 3, name: 'Tutor Test', address: 'Example Street, EX4M PL3')

@parent_rel = Parent.create!(parent_id: @parent.id, child_id: @child.id)
@tutor_rel = Tutor.create!(tutor_id: @tutor.id, pupil_id: @child.id)