class AddForeignKeystoWebmastersCms < ActiveRecord::Migration
  def change
    change_table 'webmasters_cms_page_translation_versions' do |t|
      t.foreign_key 'webmasters_cms_page_translations', :column => 'page_translation_id'
    end
    
    change_table 'webmasters_cms_page_translations' do |t|
      t.index 'local_path'
      t.foreign_key 'webmasters_cms_pages', :column => 'page_id'
    end
    
    change_table 'webmasters_cms_pages' do |t|
      t.foreign_key 'webmasters_cms_pages', :column => 'parent_id'
    end
  end
end
