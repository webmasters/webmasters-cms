class RemoveForeignKeyForWebmastersCmsPageTranslationVersionsForUnsigned < ActiveRecord::Migration
  
  def up
    change_table :webmasters_cms_page_translation_versions do |t|
      t.remove_foreign_key :name => 'webmasters_cms_page_translation_versions_page_translation_id_fk'
    end
  end
  
  def down
    change_table :webmasters_cms_page_translation_versions do |t|
      t.foreign_key :webmasters_cms_page_translations,
        :column => 'page_translation_id',
        :name => 'webmasters_cms_page_translation_versions_page_translation_id_fk'
    end
  end
end
