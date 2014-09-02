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

ActiveRecord::Schema.define(version: 20140902084347) do

  create_table "webmasters_cms_active_languages", force: true do |t|
    t.string "code", null: false
  end

  add_index "webmasters_cms_active_languages", ["code"], name: "index_webmasters_cms_active_languages_on_code", unique: true, using: :btree

  create_table "webmasters_cms_page_translation_versions", force: true do |t|
    t.integer  "page_translation_id"
    t.integer  "version"
    t.string   "name"
    t.string   "local_path"
    t.string   "title"
    t.string   "meta_description"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "language"
  end

  add_index "webmasters_cms_page_translation_versions", ["page_translation_id"], name: "index_page_versions_on_page_translation_id", using: :btree

  create_table "webmasters_cms_page_translations", force: true do |t|
    t.string   "name",             null: false
    t.string   "local_path",       null: false
    t.string   "title",            null: false
    t.string   "meta_description", null: false
    t.string   "language",         null: false
    t.text     "body",             null: false
    t.integer  "version",          null: false
    t.integer  "page_id",          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "webmasters_cms_page_translations", ["language", "local_path"], name: "wcms_pt_lang_loc_path_index", unique: true, using: :btree
  add_index "webmasters_cms_page_translations", ["language", "name"], name: "wcms_pt_lang_name_index", unique: true, using: :btree
  add_index "webmasters_cms_page_translations", ["page_id"], name: "index_webmasters_cms_page_translations_on_page_id", using: :btree

  create_table "webmasters_cms_pages", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rgt"
    t.integer  "lft"
    t.integer  "parent_id"
  end

  add_index "webmasters_cms_pages", ["lft"], name: "index_webmasters_cms_pages_on_lft", using: :btree
  add_index "webmasters_cms_pages", ["parent_id"], name: "index_webmasters_cms_pages_on_parent_id", using: :btree
  add_index "webmasters_cms_pages", ["rgt"], name: "index_webmasters_cms_pages_on_rgt", using: :btree

end
