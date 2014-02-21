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

ActiveRecord::Schema.define(version: 20140221124058) do

  create_table "iterations", force: true do |t|
    t.integer  "project_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "title"
    t.text     "theme"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects_users", id: false, force: true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", force: true do |t|
    t.integer  "user_story_id"
    t.integer  "executor_id"
    t.integer  "tester_id"
    t.string   "title"
    t.text     "description"
    t.integer  "status",         default: 0
    t.boolean  "blocked",        default: false
    t.string   "blocked_reason"
    t.float    "estimate",       default: 0.0
    t.float    "actual",         default: 0.0
    t.float    "to_do",          default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_stories", force: true do |t|
    t.integer  "project_id"
    t.integer  "iteration_id"
    t.string   "title"
    t.text     "description"
    t.integer  "status",         default: 0
    t.boolean  "ready",          default: false
    t.boolean  "blocked",        default: false
    t.string   "blocked_reason"
    t.float    "estimate",       default: 0.0
    t.float    "actual",         default: 0.0
    t.float    "to_do",          default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
