class CreateIndexesWithNewNameToWebmastersCmsPageTranslationVersionsForRails51 < ActiveRecord::Migration[5.1]
  def up
    change_table do |t|
      t.index [:page_translation_id],
        :unique => false,
        :name => "index_rails_60125973eb2bb869804dbb6b17e78b1e1f9919ad9ad45831fb"
    end
  end

  def down
    change_table do |t|
      t.remove_index :name => "index_rails_60125973eb2bb869804dbb6b17e78b1e1f9919ad9ad45831fb"
    end
  end

  private
  def change_table(&block)
    super :webmasters_cms_page_translation_versions, &block
  end
end
