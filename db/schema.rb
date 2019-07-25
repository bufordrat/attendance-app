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

ActiveRecord::Schema.define(version: 0) do

  create_table "class_meetings", force: :cascade do |t|
    t.integer "course_id"
    t.text "title"
    t.date "meeting"
    t.integer "code"
    t.boolean "is_accepting", default: false
    t.index ["course_id"], name: "index_class_meetings_on_course_id"
  end

  create_table "courses", force: :cascade do |t|
    t.text "title"
    t.text "quarter"
    t.integer "year"
  end

  create_table "presences", force: :cascade do |t|
    t.integer "user_id"
    t.integer "class_meeting_id"
    t.index ["class_meeting_id"], name: "index_presences_on_class_meeting_id"
    t.index ["user_id"], name: "index_presences_on_user_id"
  end

  create_table "submitted_codes", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at"
    t.boolean "is_legit", default: false
    t.text "code"
    t.index ["user_id"], name: "index_submitted_codes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.text "cnetid"
    t.boolean "is_teacher", default: false
    t.text "password_digest"
  end

end
