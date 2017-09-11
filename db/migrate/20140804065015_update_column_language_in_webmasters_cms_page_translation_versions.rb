class UpdateColumnLanguageInWebmastersCmsPageTranslationVersions < ActiveRecord::Migration[4.2]
  def up
    transaction do
      change_table :webmasters_cms_page_translation_versions do |t|
        t.string :language
      end
      execute 'UPDATE `webmasters_cms_page_translation_versions` SET `language`="en"'
    end
  end
end
