class MarkColumnsAsUnsignedForWebmastersCmsPageTranslationVersions < ActiveRecord::Migration
  
  def up
    change_table :webmasters_cms_page_translation_versions do |t|
      t.change :id, :integer, :unsigned => true
      t.change :page_translation_id, :integer, :unsigned => true
      t.change :version, :integer, :unsigned => true
    end
  end
  
  def down
    change_table :webmasters_cms_page_translation_versions do |t|
      t.change :id, :integer, :unsigned => false
      t.change :page_translation_id, :integer, :unsigned => false
      t.change :version, :integer, :unsigned => false
    end
  end
end
