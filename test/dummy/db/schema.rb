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

ActiveRecord::Schema.define(version: 20160425113213) do

  create_table "webmasters_cms_active_languages", id: :integer, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "code", null: false
    t.index ["code"], name: "index_webmasters_cms_active_languages_on_code", unique: true
  end

  create_table "webmasters_cms_page_translation_versions", id: :integer, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "page_translation_id", unsigned: true
    t.integer "version", unsigned: true
    t.string "name"
    t.string "local_path"
    t.string "title"
    t.string "meta_description"
    t.text "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "language"
    t.index ["page_translation_id"], name: "index_page_versions_on_page_translation_id"
  end

  create_table "webmasters_cms_page_translations", id: :integer, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.string "local_path", null: false
    t.string "title", null: false
    t.string "meta_description", null: false
    t.string "language", limit: 2, null: false
    t.text "body", null: false
    t.integer "version", default: 0, null: false, unsigned: true
    t.integer "page_id", default: 0, null: false, unsigned: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "soft_deleted", default: false, null: false
    t.boolean "redirect_to_child", default: false, null: false
    t.boolean "show_in_navigation", default: true, null: false
    t.string "redirect_to"
    t.string "menu_icon_css_class", limit: 30
    t.index ["language", "local_path"], name: "wcms_pt_lang_loc_path_index", unique: true
    t.index ["language", "name"], name: "wcms_pt_lang_name_index", unique: true
    t.index ["language"], name: "wcms_pt_lang_index"
    t.index ["local_path"], name: "index_webmasters_cms_page_translations_on_local_path"
    t.index ["page_id"], name: "wcms_pt_page_id_index"
    t.index ["soft_deleted"], name: "wcms_pt_soft_del_index"
  end

  create_table "webmasters_cms_pages", id: :integer, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "rgt", unsigned: true
    t.integer "lft", unsigned: true
    t.integer "parent_id", unsigned: true
    t.boolean "is_meta", default: false, null: false
    t.index ["is_meta"], name: "index_webmasters_cms_pages_on_is_meta"
    t.index ["lft"], name: "index_webmasters_cms_pages_on_lft"
    t.index ["parent_id"], name: "index_webmasters_cms_pages_on_parent_id"
    t.index ["rgt"], name: "index_webmasters_cms_pages_on_rgt"
  end

  add_foreign_key "webmasters_cms_page_translation_versions", "webmasters_cms_page_translations", column: "page_translation_id", name: "webmasters_cms_page_translation_versions_page_translation_id_fk"
  add_foreign_key "webmasters_cms_page_translations", "webmasters_cms_pages", column: "page_id", name: "webmasters_cms_page_translations_page_id_fk"
  add_foreign_key "webmasters_cms_pages", "webmasters_cms_pages", column: "parent_id", name: "webmasters_cms_pages_parent_id_fk"
end
