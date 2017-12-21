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

ActiveRecord::Schema.define(version: 20171221182808) do

  create_table "api_keys", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",       null: false
    t.string   "secret",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_api_keys_on_name", unique: true, using: :btree
    t.index ["secret"], name: "index_api_keys_on_secret", unique: true, using: :btree
  end

  create_table "meters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",       null: false
    t.string   "serial",     null: false
    t.integer  "capacity",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["serial"], name: "index_meters_on_serial", unique: true, using: :btree
  end

  create_table "readings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "meter_id", null: false
    t.datetime "time",     null: false
    t.integer  "value",    null: false
    t.index ["meter_id", "time"], name: "index_readings_on_meter_id_and_time", unique: true, using: :btree
    t.index ["meter_id"], name: "index_readings_on_meter_id", using: :btree
    t.index ["time"], name: "index_readings_on_time", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "user_id",    limit: 100,                 null: false
    t.string   "email",                  default: "",    null: false
    t.string   "name",                   default: "",    null: false
    t.boolean  "active",                 default: false, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.index ["user_id"], name: "index_users_on_user_id", unique: true, using: :btree
  end

  add_foreign_key "readings", "meters", on_delete: :cascade
end
