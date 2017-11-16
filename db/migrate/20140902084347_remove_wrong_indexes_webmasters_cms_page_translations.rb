class RemoveWrongIndexesWebmastersCmsPageTranslations < ActiveRecord::Migration[4.2]
  def change
    remove_index :webmasters_cms_page_translations, column: :local_path,
      :name => 'index_webmasters_cms_page_translations_on_local_path'
    remove_index :webmasters_cms_page_translations, column: :name,
      :name => 'index_webmasters_cms_page_translations_on_name'
  end
end
