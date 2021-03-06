# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_12_17_072638) do

  create_table "webmasters_cms_active_languages", id: :bigint, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "code", null: false
    t.index ["code"], name: "index_rails_a4fcee5453f5b38d3d44a0e625fefa0d2fb4cc53263b2acdee", unique: true
  end

  create_table "webmasters_cms_files", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "file_file_name"
    t.string "file_content_type"
    t.bigint "file_file_size"
    t.datetime "file_updated_at"
    t.bigint "uploaded_by_id", unsigned: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uploaded_by_id"], name: "index_webmasters_cms_files_on_uploaded_by_id"
  end

  create_table "webmasters_cms_page_translation_versions", id: :bigint, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "page_translation_id", unsigned: true
    t.integer "version", unsigned: true
    t.string "name"
    t.string "local_path"
    t.string "title"
    t.text "meta_description"
    t.text "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "language"
    t.index ["page_translation_id"], name: "index_rails_60125973eb2bb869804dbb6b17e78b1e1f9919ad9ad45831fb"
  end

  create_table "webmasters_cms_page_translations", id: :bigint, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "local_path", null: false
    t.string "title", null: false
    t.text "meta_description", null: false
    t.string "language", limit: 2, null: false
    t.text "body", null: false
    t.integer "version", default: 0, null: false, unsigned: true
    t.bigint "page_id", default: 0, null: false, unsigned: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "soft_deleted", default: false, null: false
    t.boolean "redirect_to_child", default: false, null: false
    t.boolean "show_in_navigation", default: true, null: false
    t.string "redirect_to"
    t.string "menu_icon_css_class", limit: 30
    t.index ["language"], name: "index_rails_65e51d22ba2ff39d6cda11b1547087c8236643b51b2c40e89e"
    t.index ["local_path"], name: "index_rails_8f8a6dada8e0fbed5e83814872245f667ee34bdb7e73c03323"
    t.index ["page_id"], name: "index_rails_4629fc97ca42721a5046a209a4628166afd9c85b704a33048e"
    t.index ["soft_deleted"], name: "index_rails_84406cbb11c1e194c9a3108685e7a364f2d60d3fae9dbf63f5"
  end

  create_table "webmasters_cms_pages", id: :bigint, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "rgt", unsigned: true
    t.integer "lft", unsigned: true
    t.bigint "parent_id", unsigned: true
    t.boolean "is_meta", default: false, null: false
    t.integer "host_index", default: 0, null: false, unsigned: true
    t.index ["is_meta"], name: "index_rails_42711403a23f14dddfa0e74ab1afffc2e5522e658885fffa7b"
    t.index ["lft"], name: "index_rails_ae6c3a836b7590b6aa40729dd26cadfe069994230b7045945a"
    t.index ["parent_id"], name: "index_rails_a2d564f7616879db19d943a1f651b4cd5747505295c0abc2ac"
    t.index ["rgt"], name: "index_rails_8dde03030edc7be390b2a04aee530ca052e0e69a618ef6162d"
  end

  add_foreign_key "webmasters_cms_page_translation_versions", "webmasters_cms_page_translations", column: "page_translation_id", name: "fk_rails_53d16e8057f13da3acf7c25beb69754f3c7f269786436c1b32"
  add_foreign_key "webmasters_cms_page_translations", "webmasters_cms_pages", column: "page_id", name: "fk_rails_5d3e1069d5f9a64d830f314d600139b10abb59d5455e39db7a"
  add_foreign_key "webmasters_cms_pages", "webmasters_cms_pages", column: "parent_id", name: "fk_rails_b6d179f800504cc308d42c55d972ae950343e73e91c53a9928"
end
