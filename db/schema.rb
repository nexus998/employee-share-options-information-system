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

ActiveRecord::Schema[7.0].define(version: 2022_04_28_114701) do
  create_table "employee_data", force: :cascade do |t|
    t.string "employee_id"
    t.integer "field_id"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["field_id"], name: "index_employee_data_on_field_id"
  end

  create_table "employee_data_options_calculations", id: false, force: :cascade do |t|
    t.integer "employee_datum_id", null: false
    t.integer "options_calculation_id", null: false
  end

  create_table "fields", force: :cascade do |t|
    t.string "name"
    t.string "field_type"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "grant_rules", force: :cascade do |t|
    t.integer "grant_type_id", null: false
    t.string "vesting_start"
    t.string "cliff"
    t.string "tranches"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "trigger"
    t.string "share_number"
    t.index ["grant_type_id"], name: "index_grant_rules_on_grant_type_id"
  end

  create_table "grant_types", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "cliff_percentage"
  end

  create_table "options_calculations", force: :cascade do |t|
    t.string "employee_id"
    t.date "grant_date"
    t.date "vesting_start_date"
    t.integer "cliff"
    t.integer "tranches"
    t.integer "grant_type_id", null: false
    t.decimal "share_number"
    t.date "vesting_end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "verified"
    t.index ["grant_type_id"], name: "index_options_calculations_on_grant_type_id"
  end

  create_table "options_profile_maps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "values"
    t.integer "options_profiles_id"
    t.index ["options_profiles_id"], name: "index_options_profile_maps_on_options_profiles_id"
  end

  create_table "options_profiles", force: :cascade do |t|
    t.string "label"
    t.integer "monetary_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "participants", force: :cascade do |t|
    t.string "email"
    t.string "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role_id", null: false
    t.index ["role_id"], name: "index_participants_on_role_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.integer "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "photo_url"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "employee_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "valuations", force: :cascade do |t|
    t.decimal "market_price"
    t.decimal "strike_price"
    t.date "effective_date"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "employee_data", "fields"
  add_foreign_key "grant_rules", "grant_types"
  add_foreign_key "options_calculations", "grant_types"
  add_foreign_key "options_profile_maps", "options_profiles", column: "options_profiles_id"
  add_foreign_key "participants", "roles"
end
