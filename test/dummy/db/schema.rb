# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150101000000) do

  create_table "rollenspiel_persisted_roles", force: :cascade do |t|
    t.string   "name",          limit: 255,             null: false
    t.integer  "revoked",       limit: 1,   default: 0, null: false
    t.integer  "grantee_id",                            null: false
    t.string   "grantee_type",                          null: false
    t.integer  "provider_id"
    t.string   "provider_type"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "rollenspiel_persisted_roles", ["name"], name: "index_rollenspiel_persisted_roles_on_name"
  add_index "rollenspiel_persisted_roles", ["revoked"], name: "index_rollenspiel_persisted_roles_on_revoked"

  create_table "test_animals", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "test_departments", force: :cascade do |t|
    t.string   "name"
    t.integer  "test_organization_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "test_departments", ["test_organization_id"], name: "index_test_departments_on_test_organization_id"

  create_table "test_organizations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "test_users", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
