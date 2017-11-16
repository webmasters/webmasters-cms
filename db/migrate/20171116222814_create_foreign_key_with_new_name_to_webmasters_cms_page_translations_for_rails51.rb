class CreateForeignKeyWithNewNameToWebmastersCmsPageTranslationsForRails51 < ActiveRecord::Migration[5.1]
  def up
    change_table do |t|
      t.foreign_key :webmasters_cms_pages, :column => "page_id",
        :name => "fk_rails_5d3e1069d5f9a64d830f314d600139b10abb59d5455e39db7a"
    end
  end

  def down
    change_table do |t|
      t.remove_foreign_key :column => "page_id",
        :name => "fk_rails_5d3e1069d5f9a64d830f314d600139b10abb59d5455e39db7a"
    end
  end

  private
  def change_table(&block)
    super :webmasters_cms_page_translations, &block
  end
end
