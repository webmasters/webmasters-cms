class AddForeignKeystoWebmastersCms < ActiveRecord::Migration[4.2]
  def change
    change_table 'webmasters_cms_page_translation_versions' do |t|
      t.foreign_key 'webmasters_cms_page_translations', :column => 'page_translation_id',
        :name => 'webmasters_cms_page_translation_versions_page_translation_id_fk'
    end
    
    change_table 'webmasters_cms_page_translations' do |t|
      t.index 'local_path',
        :name => 'index_webmasters_cms_page_translation_versions_on_local_path'
      t.foreign_key 'webmasters_cms_pages', :column => 'page_id',
        :name => 'webmasters_cms_page_translation_versions_page_id_fk'
    end
    
    change_table 'webmasters_cms_pages' do |t|
      t.foreign_key 'webmasters_cms_pages', :column => 'parent_id',
        :name => 'webmasters_cms_page_translation_versions_parent_id_fk'
    end
  end
end
