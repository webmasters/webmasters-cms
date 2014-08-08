class RenameTableWebmastersCmsPageVersionsWebmastersCmsPageTranslationVersions < ActiveRecord::Migration
  def change
    remove_index :webmasters_cms_page_versions, :page_id
    rename_table :webmasters_cms_page_versions, :webmasters_cms_page_translation_versions
  end
end
