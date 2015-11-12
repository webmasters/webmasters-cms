class RemoveForeignKeyForWebmastersCmsPageTranslationsForUnsigned < ActiveRecord::Migration
  
  def up
    change_table :webmasters_cms_page_translations do |t|
      t.remove_foreign_key :name => 'webmasters_cms_page_translations_page_id_fk'
    end
  end
  
  def down
    change_table :webmasters_cms_page_translations do |t|
      t.foreign_key :webmasters_cms_pages,
        :column => 'page_id',
        :name => 'webmasters_cms_page_translations_page_id_fk'
    end
  end
end
