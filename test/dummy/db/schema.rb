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

ActiveRecord::Schema.define(version: 20151112081156) do

  create_table "webmasters_cms_active_languages", force: :cascade do |t|
    t.string "code", limit: 255, null: false
  end

  add_index "webmasters_cms_active_languages", ["code"], name: "index_webmasters_cms_active_languages_on_code", unique: true, using: :btree

  create_table "webmasters_cms_page_translation_versions", force: :cascade do |t|
    t.integer  "page_translation_id", limit: 4
    t.integer  "version",             limit: 4
    t.string   "name",                limit: 255
    t.string   "local_path",          limit: 255
    t.string   "title",               limit: 255
    t.string   "meta_description",    limit: 255
    t.text     "body",                limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "language",            limit: 255
  end

  add_index "webmasters_cms_page_translation_versions", ["page_translation_id"], name: "index_page_versions_on_page_translation_id", using: :btree

  create_table "webmasters_cms_page_translations", force: :cascade do |t|
    t.string   "name",               limit: 255,                   null: false
    t.string   "local_path",         limit: 255,                   null: false
    t.string   "title",              limit: 255,                   null: false
    t.string   "meta_description",   limit: 255,                   null: false
    t.string   "language",           limit: 2,                     null: false
    t.text     "body",               limit: 65535,                 null: false
    t.integer  "version",            limit: 4,     default: 0,     null: false
    t.integer  "page_id",            limit: 4,     default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "soft_deleted",                     default: false, null: false
    t.boolean  "redirect_to_child",                default: false, null: false
    t.boolean  "show_in_navigation",               default: true,  null: false
    t.string   "redirect_to",        limit: 255
  end

  add_index "webmasters_cms_page_translations", ["language", "local_path"], name: "wcms_pt_lang_loc_path_index", unique: true, using: :btree
  add_index "webmasters_cms_page_translations", ["language", "name"], name: "wcms_pt_lang_name_index", unique: true, using: :btree
  add_index "webmasters_cms_page_translations", ["language"], name: "wcms_pt_lang_index", using: :btree
  add_index "webmasters_cms_page_translations", ["local_path"], name: "index_webmasters_cms_page_translations_on_local_path", using: :btree
  add_index "webmasters_cms_page_translations", ["page_id"], name: "wcms_pt_page_id_index", using: :btree
  add_index "webmasters_cms_page_translations", ["soft_deleted"], name: "wcms_pt_soft_del_index", using: :btree

  create_table "webmasters_cms_pages", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rgt",        limit: 4
    t.integer  "lft",        limit: 4
    t.integer  "parent_id",  limit: 4
    t.boolean  "is_meta",              default: false, null: false
  end

  add_index "webmasters_cms_pages", ["is_meta"], name: "index_webmasters_cms_pages_on_is_meta", using: :btree
  add_index "webmasters_cms_pages", ["lft"], name: "index_webmasters_cms_pages_on_lft", using: :btree
  add_index "webmasters_cms_pages", ["parent_id"], name: "index_webmasters_cms_pages_on_parent_id", using: :btree
  add_index "webmasters_cms_pages", ["rgt"], name: "index_webmasters_cms_pages_on_rgt", using: :btree

  add_foreign_key "webmasters_cms_page_translation_versions", "webmasters_cms_page_translations", column: "page_translation_id", name: "webmasters_cms_page_translation_versions_page_translation_id_fk"
  add_foreign_key "webmasters_cms_page_translations", "webmasters_cms_pages", column: "page_id", name: "webmasters_cms_page_translations_page_id_fk"
  add_foreign_key "webmasters_cms_pages", "webmasters_cms_pages", column: "parent_id", name: "webmasters_cms_pages_parent_id_fk"
end
