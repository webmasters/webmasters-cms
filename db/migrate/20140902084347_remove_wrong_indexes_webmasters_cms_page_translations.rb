class RemoveWrongIndexesWebmastersCmsPageTranslations < ActiveRecord::Migration[4.2]
  def change
    remove_index :webmasters_cms_page_translations, column: :local_path
    remove_index :webmasters_cms_page_translations, column: :name
  end
end
