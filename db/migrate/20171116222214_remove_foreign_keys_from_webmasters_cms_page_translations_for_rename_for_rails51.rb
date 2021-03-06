class RemoveForeignKeysFromWebmastersCmsPageTranslationsForRenameForRails51 < ActiveRecord::Migration[5.1]
  def up
    change_table do |t|
      t.remove_foreign_key :column => "page_id",
        :name => "webmasters_cms_page_translations_page_id_fk"
    end
  end

  def down
    change_table do |t|
      t.foreign_key :webmasters_cms_pages, :column => "page_id",
        :name => "webmasters_cms_page_translations_page_id_fk"
    end
  end

  private
  def change_table(&block)
    super :webmasters_cms_page_translations, &block
  end
end
