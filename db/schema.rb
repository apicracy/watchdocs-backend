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

ActiveRecord::Schema.define(version: 20170629215514) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "channels", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "notificable_type"
    t.integer  "notificable_id"
    t.integer  "provider"
    t.boolean  "active",           default: true
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "documents", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "group_id"
    t.string   "name"
    t.string   "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_documents_on_group_id", using: :btree
    t.index ["project_id"], name: "index_documents_on_project_id", using: :btree
  end

  create_table "endpoints", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "project_id"
    t.string   "url"
    t.string   "http_method"
    t.integer  "status"
    t.string   "title"
    t.text     "summary"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["group_id"], name: "index_endpoints_on_group_id", using: :btree
    t.index ["project_id"], name: "index_endpoints_on_project_id", using: :btree
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "groups", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "group_id"
    t.string   "name"
    t.string   "path"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["group_id"], name: "index_groups_on_group_id", using: :btree
    t.index ["project_id"], name: "index_groups_on_project_id", using: :btree
  end

  create_table "headers", force: :cascade do |t|
    t.string   "headerable_type"
    t.integer  "headerable_id"
    t.string   "key"
    t.boolean  "required"
    t.string   "description"
    t.string   "example_value"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["headerable_type", "headerable_id"], name: "index_headers_on_headerable_type_and_headerable_id", using: :btree
  end

  create_table "jwt_blacklist", force: :cascade do |t|
    t.string "jti", null: false
    t.index ["jti"], name: "index_jwt_blacklist_on_jti", using: :btree
  end

  create_table "projects", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "base_url"
    t.string   "app_id"
    t.string   "app_secret"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "sample"
    t.string   "slug"
    t.boolean  "public",     default: false
    t.index ["slug"], name: "index_projects_on_slug", unique: true, using: :btree
    t.index ["user_id"], name: "index_projects_on_user_id", using: :btree
  end

  create_table "push_notifications_credentials", force: :cascade do |t|
    t.string   "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_push_notifications_credentials_on_player_id", using: :btree
  end

  create_table "requests", force: :cascade do |t|
    t.integer  "endpoint_id"
    t.integer  "status"
    t.jsonb    "body"
    t.jsonb    "body_draft"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["endpoint_id"], name: "index_requests_on_endpoint_id", using: :btree
  end

  create_table "responses", force: :cascade do |t|
    t.integer  "endpoint_id"
    t.integer  "http_status_code"
    t.integer  "status"
    t.jsonb    "body"
    t.jsonb    "body_draft"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["endpoint_id"], name: "index_responses_on_endpoint_id", using: :btree
  end

  create_table "slack_credentials", force: :cascade do |t|
    t.string   "access_token"
    t.string   "webhook_url"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "tree_items", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "itemable_type"
    t.integer  "itemable_id"
    t.integer  "parent_id"
    t.integer  "position"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["itemable_type", "itemable_id"], name: "index_tree_items_on_itemable_type_and_itemable_id", using: :btree
    t.index ["project_id"], name: "index_tree_items_on_project_id", using: :btree
  end

  create_table "url_params", force: :cascade do |t|
    t.integer  "endpoint_id"
    t.string   "name"
    t.integer  "status"
    t.boolean  "required"
    t.string   "data_type"
    t.text     "description"
    t.string   "example"
    t.boolean  "is_part_of_url"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.boolean  "required_draft"
    t.index ["endpoint_id"], name: "index_url_params_on_endpoint_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "encrypted_password",     default: "", null: false
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  add_foreign_key "documents", "groups"
  add_foreign_key "documents", "projects"
  add_foreign_key "endpoints", "groups"
  add_foreign_key "endpoints", "projects"
  add_foreign_key "groups", "groups"
  add_foreign_key "groups", "projects"
  add_foreign_key "projects", "users"
  add_foreign_key "requests", "endpoints"
  add_foreign_key "responses", "endpoints"
  add_foreign_key "tree_items", "projects"
  add_foreign_key "url_params", "endpoints"
end
