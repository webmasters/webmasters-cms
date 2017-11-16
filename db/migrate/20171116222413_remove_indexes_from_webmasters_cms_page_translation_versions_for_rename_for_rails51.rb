class RemoveIndexesFromWebmastersCmsPageTranslationVersionsForRenameForRails51 < ActiveRecord::Migration[5.1]
  def up
    change_table do |t|
      t.remove_index :name => "index_page_versions_on_page_translation_id"
    end
  end

  def down
    change_table do |t|
      t.index [:page_translation_id],
        :unique => false,
        :name => "index_page_versions_on_page_translation_id"
    end
  end

  private
  def change_table(&block)
    super :webmasters_cms_page_translation_versions, &block
  end
end
