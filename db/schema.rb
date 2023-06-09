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

ActiveRecord::Schema[7.0].define(version: 2020_06_28_114604) do
  create_table "api_keys", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "secret", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_api_keys_on_name", unique: true
    t.index ["secret"], name: "index_api_keys_on_secret", unique: true
  end

  create_table "energy_source_estimates", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.integer "meter_id", null: false
    t.datetime "time", precision: nil, null: false
    t.integer "generated", null: false
    t.integer "imported", null: false
    t.index ["meter_id", "time"], name: "index_energy_source_estimates_on_meter_id_and_time", unique: true
    t.index ["meter_id"], name: "index_energy_source_estimates_on_meter_id"
  end

  create_table "meters", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "serial", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "site_id"
    t.integer "meter_type", default: 0, null: false
    t.integer "current_duration", default: 300, null: false
    t.boolean "active", default: true, null: false
    t.index ["serial"], name: "index_meters_on_serial", unique: true
    t.index ["site_id"], name: "index_meters_on_site_id"
  end

  create_table "rates", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.integer "site_id", null: false
    t.date "valid_from", null: false
    t.decimal "import_rate", precision: 6, scale: 4, null: false
    t.decimal "export_rate", precision: 6, scale: 4, null: false
    t.decimal "self_consume_rate", precision: 6, scale: 4, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["site_id"], name: "index_rates_on_site_id"
  end

  create_table "readings", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.integer "meter_id", null: false
    t.datetime "time", precision: nil, null: false
    t.integer "value", null: false
    t.index ["meter_id", "time"], name: "index_readings_on_meter_id_and_time", unique: true
    t.index ["meter_id"], name: "index_readings_on_meter_id"
    t.index ["time"], name: "index_readings_on_time"
  end

  create_table "sites", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "external_link"
  end

  create_table "users", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.string "user_id", limit: 100, null: false
    t.string "email", default: "", null: false
    t.string "name", default: "", null: false
    t.boolean "active", default: false, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_users_on_user_id", unique: true
  end

  add_foreign_key "energy_source_estimates", "meters", on_delete: :cascade
  add_foreign_key "rates", "sites", on_delete: :cascade
  add_foreign_key "readings", "meters", on_delete: :cascade
end
