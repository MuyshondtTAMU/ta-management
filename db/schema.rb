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

ActiveRecord::Schema[7.0].define(version: 2022_10_04_173444) do
  create_table "students", force: :cascade do |t|
    t.string "name"
    t.string "email_id"
    t.string "password"
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
  end

end
