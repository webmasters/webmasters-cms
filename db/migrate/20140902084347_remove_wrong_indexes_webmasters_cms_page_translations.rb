class RemoveWrongIndexesWebmastersCmsPageTranslations < ActiveRecord::Migration
  def change
    remove_index :webmasters_cms_page_translations, column: :local_path
    remove_index :webmasters_cms_page_translations, column: :name
  end
end
