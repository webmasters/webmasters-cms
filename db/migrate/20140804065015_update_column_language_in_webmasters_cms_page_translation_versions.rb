class UpdateColumnLanguageInWebmastersCmsPageTranslationVersions < ActiveRecord::Migration
  def up
    transaction do
      execute 'UPDATE `webmasters_cms_page_translation_versions` SET `language`="en"'
    end
  end
end
