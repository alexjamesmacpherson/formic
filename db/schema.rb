# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170302162433) do

  create_table "assignments", force: :cascade do |t|
    t.integer  "subject_id"
    t.string   "name"
    t.text     "information"
    t.datetime "due"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["subject_id"], name: "index_assignments_on_subject_id"
  end

  create_table "departments", force: :cascade do |t|
    t.integer  "school_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "head_id"
    t.index ["head_id"], name: "index_departments_on_head_id"
    t.index ["school_id"], name: "index_departments_on_school_id"
  end

  create_table "parents", force: :cascade do |t|
    t.integer  "parent_id"
    t.integer  "child_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["child_id"], name: "index_parents_on_child_id"
    t.index ["parent_id", "child_id"], name: "index_parents_on_parent_id_and_child_id", unique: true
    t.index ["parent_id"], name: "index_parents_on_parent_id"
  end

  create_table "schools", force: :cascade do |t|
    t.string   "name"
    t.string   "motto"
    t.text     "address"
    t.string   "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "studies", force: :cascade do |t|
    t.integer  "subject_id"
    t.integer  "pupil_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "target",     default: ""
    t.string   "expected",   default: ""
    t.index ["pupil_id"], name: "index_studies_on_pupil_id"
    t.index ["subject_id", "pupil_id"], name: "index_studies_on_subject_id_and_pupil_id", unique: true
    t.index ["subject_id"], name: "index_studies_on_subject_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.integer  "department_id"
    t.string   "name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "year_group_id"
    t.index ["department_id"], name: "index_subjects_on_department_id"
    t.index ["year_group_id"], name: "index_subjects_on_year_group_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.integer  "assignment_id"
    t.integer  "pupil_id"
    t.string   "file"
    t.boolean  "submitted",     default: false
    t.datetime "submitted_at"
    t.integer  "marker_id"
    t.boolean  "marked",        default: false
    t.datetime "marked_at"
    t.text     "feedback"
    t.string   "grade"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["assignment_id", "pupil_id"], name: "index_submissions_on_assignment_id_and_pupil_id", unique: true
    t.index ["assignment_id"], name: "index_submissions_on_assignment_id"
    t.index ["marker_id"], name: "index_submissions_on_marker_id"
    t.index ["pupil_id"], name: "index_submissions_on_pupil_id"
  end

  create_table "teaches", force: :cascade do |t|
    t.integer  "subject_id"
    t.integer  "teacher_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_id", "teacher_id"], name: "index_teaches_on_subject_id_and_teacher_id", unique: true
    t.index ["subject_id"], name: "index_teaches_on_subject_id"
    t.index ["teacher_id"], name: "index_teaches_on_teacher_id"
  end

  create_table "tutors", force: :cascade do |t|
    t.integer  "tutor_id"
    t.integer  "pupil_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pupil_id"], name: "index_tutors_on_pupil_id"
    t.index ["tutor_id", "pupil_id"], name: "index_tutors_on_tutor_id_and_pupil_id", unique: true
    t.index ["tutor_id"], name: "index_tutors_on_tutor_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer  "school_id"
    t.string   "email"
    t.integer  "group",             default: 1
    t.string   "name"
    t.text     "bio",               default: ""
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.integer  "year_group_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["school_id"], name: "index_users_on_school_id"
    t.index ["year_group_id"], name: "index_users_on_year_group_id"
  end

  create_table "year_groups", force: :cascade do |t|
    t.integer  "school_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id"], name: "index_year_groups_on_school_id"
  end

end
