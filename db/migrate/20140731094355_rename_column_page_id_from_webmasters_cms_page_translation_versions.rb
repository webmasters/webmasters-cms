class RenameColumnPageIdFromWebmastersCmsPageTranslationVersions < ActiveRecord::Migration
  def change
    rename_column :webmasters_cms_page_translation_versions, :page_id, :page_translation_id
    add_index :webmasters_cms_page_translation_versions, [:page_translation_id], name: :index_page_versions_on_page_translation_id
  end
end
