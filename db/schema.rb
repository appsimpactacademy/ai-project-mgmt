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

ActiveRecord::Schema[7.0].define(version: 2024_06_24_141415) do
  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.text "about"
    t.string "email"
    t.string "contact_number"
    t.string "domain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employee_projects", force: :cascade do |t|
    t.integer "employee_id", null: false
    t.integer "project_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.string "role"
    t.string "current_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_employee_projects_on_employee_id"
    t.index ["project_id"], name: "index_employee_projects_on_project_id"
  end

  create_table "employee_skills", force: :cascade do |t|
    t.integer "employee_id", null: false
    t.integer "skill_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_employee_skills_on_employee_id"
    t.index ["skill_id"], name: "index_employee_skills_on_skill_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "contact_number"
    t.string "job_title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "role"
    t.integer "company_id"
    t.index ["email"], name: "index_employees_on_email", unique: true
    t.index ["reset_password_token"], name: "index_employees_on_reset_password_token", unique: true
  end

  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.string "client_name"
    t.string "client_company"
    t.date "start_date"
    t.date "end_date"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string "number"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "time_logs", force: :cascade do |t|
    t.string "description"
    t.float "time_in_hours"
    t.string "status"
    t.date "log_date"
    t.string "task_type"
    t.integer "employee_id", null: false
    t.integer "task_id", null: false
    t.integer "employee_project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_time_logs_on_employee_id"
    t.index ["employee_project_id"], name: "index_time_logs_on_employee_project_id"
    t.index ["task_id"], name: "index_time_logs_on_task_id"
  end

  add_foreign_key "employee_projects", "employees"
  add_foreign_key "employee_projects", "projects"
  add_foreign_key "employee_skills", "employees"
  add_foreign_key "employee_skills", "skills"
  add_foreign_key "time_logs", "employee_projects"
  add_foreign_key "time_logs", "employees"
  add_foreign_key "time_logs", "tasks"
end
