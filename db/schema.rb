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

ActiveRecord::Schema.define(version: 20160113222547) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "canteen_ads", force: :cascade do |t|
    t.string   "name"
    t.text     "content"
    t.datetime "date"
    t.integer  "canteen_worker_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "canteen_ads", ["canteen_worker_id"], name: "index_canteen_ads_on_canteen_worker_id", using: :btree

  create_table "canteen_onlines", force: :cascade do |t|
    t.time     "start_time"
    t.time     "end_time"
    t.integer  "canteen_id"
    t.integer  "stair_layer_id"
    t.integer  "day_category_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "canteen_onlines", ["canteen_id"], name: "index_canteen_onlines_on_canteen_id", using: :btree
  add_index "canteen_onlines", ["day_category_id"], name: "index_canteen_onlines_on_day_category_id", using: :btree
  add_index "canteen_onlines", ["stair_layer_id"], name: "index_canteen_onlines_on_stair_layer_id", using: :btree

  create_table "canteen_windows", force: :cascade do |t|
    t.string   "name"
    t.integer  "stair_layer_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "canteen_windows", ["stair_layer_id"], name: "index_canteen_windows_on_stair_layer_id", using: :btree

  create_table "canteen_workers", force: :cascade do |t|
    t.string   "account"
    t.string   "password"
    t.integer  "gender"
    t.datetime "login_time"
    t.integer  "visit_count"
    t.integer  "reference_id"
    t.integer  "granted_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "name"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "canteen_workers", ["granted_id"], name: "index_canteen_workers_on_granted_id", using: :btree

  create_table "canteens", force: :cascade do |t|
    t.string   "name"
    t.string   "photo_path"
    t.integer  "region_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "canteens", ["region_id"], name: "index_canteens_on_region_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "ancestor_id"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "comment_time"
    t.integer  "dish_id"
    t.integer  "comment_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "comments", ["comment_id"], name: "index_comments_on_comment_id", using: :btree
  add_index "comments", ["dish_id"], name: "index_comments_on_dish_id", using: :btree

  create_table "day_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dish_types", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "dish_votes", force: :cascade do |t|
    t.integer  "rating"
    t.integer  "student_id"
    t.integer  "publish_dish_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "dish_votes", ["publish_dish_id"], name: "index_dish_votes_on_publish_dish_id", using: :btree
  add_index "dish_votes", ["student_id"], name: "index_dish_votes_on_student_id", using: :btree

  create_table "dishes", force: :cascade do |t|
    t.string   "name"
    t.decimal  "price",        precision: 10, scale: 2
    t.datetime "add_time"
    t.text     "description"
    t.string   "photo"
    t.integer  "dish_type_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "dishes", ["dish_type_id"], name: "index_dishes_on_dish_type_id", using: :btree

  create_table "granteds", force: :cascade do |t|
    t.integer  "grade"
    t.string   "table_name"
    t.string   "alias"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "publish_dishes", force: :cascade do |t|
    t.date     "time"
    t.text     "description"
    t.integer  "dish_id"
    t.integer  "day_category_id"
    t.integer  "canteen_worker_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "publish_dishes", ["canteen_worker_id"], name: "index_publish_dishes_on_canteen_worker_id", using: :btree
  add_index "publish_dishes", ["day_category_id"], name: "index_publish_dishes_on_day_category_id", using: :btree
  add_index "publish_dishes", ["dish_id"], name: "index_publish_dishes_on_dish_id", using: :btree

  create_table "recommend_dish_replies", force: :cascade do |t|
    t.integer  "accepted"
    t.text     "reason"
    t.integer  "canteen_id"
    t.integer  "recommend_dish_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "recommend_dish_replies", ["canteen_id"], name: "index_recommend_dish_replies_on_canteen_id", using: :btree
  add_index "recommend_dish_replies", ["recommend_dish_id"], name: "index_recommend_dish_replies_on_recommend_dish_id", using: :btree

  create_table "recommend_dishes", force: :cascade do |t|
    t.string   "name"
    t.datetime "recommend_time"
    t.text     "method_reason"
    t.string   "photo"
    t.integer  "reference_id"
    t.integer  "student_id"
    t.integer  "granted_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "recommend_dishes", ["granted_id"], name: "index_recommend_dishes_on_granted_id", using: :btree
  add_index "recommend_dishes", ["student_id"], name: "index_recommend_dishes_on_student_id", using: :btree

  create_table "regions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stair_layers", force: :cascade do |t|
    t.integer  "layer"
    t.integer  "canteen_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "stair_layers", ["canteen_id"], name: "index_stair_layers_on_canteen_id", using: :btree

  create_table "students", force: :cascade do |t|
    t.string   "account"
    t.string   "password"
    t.integer  "gender"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "name"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "email"
    t.string   "activation_token"
    t.string   "reset_token"
  end

  add_foreign_key "canteen_ads", "canteen_workers"
  add_foreign_key "canteen_onlines", "canteens"
  add_foreign_key "canteen_onlines", "day_categories"
  add_foreign_key "canteen_onlines", "stair_layers"
  add_foreign_key "canteen_windows", "stair_layers"
  add_foreign_key "canteen_workers", "granteds"
  add_foreign_key "canteens", "regions"
  add_foreign_key "comments", "comments"
  add_foreign_key "comments", "dishes"
  add_foreign_key "dish_votes", "publish_dishes"
  add_foreign_key "dish_votes", "students"
  add_foreign_key "dishes", "dish_types"
  add_foreign_key "publish_dishes", "canteen_workers"
  add_foreign_key "publish_dishes", "day_categories"
  add_foreign_key "publish_dishes", "dishes"
  add_foreign_key "recommend_dish_replies", "canteens"
  add_foreign_key "recommend_dish_replies", "recommend_dishes"
  add_foreign_key "recommend_dishes", "granteds"
  add_foreign_key "recommend_dishes", "students"
  add_foreign_key "stair_layers", "canteens"
end
