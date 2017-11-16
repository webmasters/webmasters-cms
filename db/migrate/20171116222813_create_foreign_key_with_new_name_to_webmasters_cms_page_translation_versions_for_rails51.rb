class CreateForeignKeyWithNewNameToWebmastersCmsPageTranslationVersionsForRails51 < ActiveRecord::Migration[5.1]
  def up
    change_table do |t|
      t.foreign_key :webmasters_cms_page_translations, :column => "page_translation_id",
        :name => "fk_rails_53d16e8057f13da3acf7c25beb69754f3c7f269786436c1b32"
    end
  end

  def down
    change_table do |t|
      t.remove_foreign_key :column => "page_translation_id",
        :name => "fk_rails_53d16e8057f13da3acf7c25beb69754f3c7f269786436c1b32"
    end
  end

  private
  def change_table(&block)
    super :webmasters_cms_page_translation_versions, &block
  end
end
