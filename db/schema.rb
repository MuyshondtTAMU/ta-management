# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_10_05_053343) do
  create_table "managements", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.string "name"
    t.index ["user_id"], name: "index_managements_on_user_id"
  end

  create_table "professors", force: :cascade do |t|
    t.string "course_list"
    t.string "course_section"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.string "name"
    t.index ["user_id"], name: "index_professors_on_user_id"
  end

  create_table "students", force: :cascade do |t|
    t.boolean "employment_status", default: false
    t.boolean "is_undergrad"
    t.text "courses_completed"
    t.string "application_status"
    t.string "comments"
    t.string "assigned_courses"
    t.string "assigned_sections"
    t.integer "rating", limit: 10
    t.string "feedback"
    t.text "access_level", default: "[\"applicant\"]"
    t.binary "resume"
    t.binary "transcript"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "contact"
    t.boolean "is_active"
    t.integer "user_id", null: false
    t.string "name"
    t.integer "uin"
    t.index ["user_id"], name: "index_students_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_id"
    t.string "password"
    t.string "access_level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "managements", "users"
  add_foreign_key "professors", "users"
  add_foreign_key "students", "users"
end
