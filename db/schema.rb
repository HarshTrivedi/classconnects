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

ActiveRecord::Schema.define(version: 20150312102110) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "branches", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "buckets", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "category_id"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "buckets", ["category_id"], name: "index_buckets_on_category_id", using: :btree
  add_index "buckets", ["course_id"], name: "index_buckets_on_course_id", using: :btree

  create_table "categories", force: true do |t|
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "college_branch_pairs", force: true do |t|
    t.integer  "college_id"
    t.integer  "branch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "college_branch_pairs", ["branch_id"], name: "index_college_branch_pairs_on_branch_id", using: :btree
  add_index "college_branch_pairs", ["college_id"], name: "index_college_branch_pairs_on_college_id", using: :btree

  create_table "colleges", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comment_responses", force: true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.string   "message",    default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comment_responses", ["comment_id"], name: "index_comment_responses_on_comment_id", using: :btree
  add_index "comment_responses", ["user_id"], name: "index_comment_responses_on_user_id", using: :btree

  create_table "comments", force: true do |t|
    t.integer  "user_id"
    t.string   "message",          default: "", null: false
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "course_enrollments", force: true do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "course_enrollments", ["course_id"], name: "index_course_enrollments_on_course_id", using: :btree
  add_index "course_enrollments", ["user_id"], name: "index_course_enrollments_on_user_id", using: :btree

  create_table "course_favorites", force: true do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "course_favorites", ["course_id"], name: "index_course_favorites_on_course_id", using: :btree
  add_index "course_favorites", ["user_id"], name: "index_course_favorites_on_user_id", using: :btree

  create_table "courses", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.text     "professors",             default: [], array: true
    t.integer  "college_branch_pair_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "courses", ["college_branch_pair_id"], name: "index_courses_on_college_branch_pair_id", using: :btree

  create_table "documents", force: true do |t|
    t.integer  "folder_id"
    t.string   "cloud_path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "documents", ["folder_id"], name: "index_documents_on_folder_id", using: :btree

  create_table "downloads", force: true do |t|
    t.integer  "user_id"
    t.integer  "bucket_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "downloads", ["bucket_id"], name: "index_downloads_on_bucket_id", using: :btree
  add_index "downloads", ["user_id"], name: "index_downloads_on_user_id", using: :btree

  create_table "folders", force: true do |t|
    t.string   "name"
    t.integer  "folder_id"
    t.integer  "bucket_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "folders", ["bucket_id"], name: "index_folders_on_bucket_id", using: :btree
  add_index "folders", ["folder_id"], name: "index_folders_on_folder_id", using: :btree

  create_table "uploads", force: true do |t|
    t.integer  "user_id"
    t.integer  "bucket_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "uploads", ["bucket_id"], name: "index_uploads_on_bucket_id", using: :btree
  add_index "uploads", ["user_id"], name: "index_uploads_on_user_id", using: :btree

  create_table "user_college_branch_enrollments", force: true do |t|
    t.integer  "user_id"
    t.integer  "college_branch_pair_id"
    t.datetime "college_enrollment_year"
    t.datetime "exprected_year_completion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_college_branch_enrollments", ["college_branch_pair_id"], name: "index_user_college_branch_enrollments_on_college_branch_pair_id", using: :btree
  add_index "user_college_branch_enrollments", ["user_id"], name: "index_user_college_branch_enrollments_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
