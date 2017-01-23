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

ActiveRecord::Schema.define(version: 20170123100225) do

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
    t.string   "phone_number"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
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
    t.integer  "user_group", default: 1
    t.string   "name"
    t.text     "bio"
    t.text     "address"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["school_id"], name: "index_users_on_school_id"
  end

end
