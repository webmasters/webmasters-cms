class CreateUniqueIndexWebmastersCmsPageTranslations < ActiveRecord::Migration[4.2]
  def change
    add_index :webmasters_cms_page_translations, [:language, :name], name: 'wcms_pt_lang_name_index', unique: true
    add_index :webmasters_cms_page_translations, [:language, :local_path], name: 'wcms_pt_lang_loc_path_index', unique: true
  end
end