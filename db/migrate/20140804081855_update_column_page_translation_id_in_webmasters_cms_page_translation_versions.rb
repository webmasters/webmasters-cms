class UpdateColumnPageTranslationIdInWebmastersCmsPageTranslationVersions < ActiveRecord::Migration
  def up
    transaction do
      execute "UPDATE webmasters_cms_page_translation_versions 
        INNER JOIN webmasters_cms_page_translations 
        ON webmasters_cms_page_translation_versions.page_translation_id = webmasters_cms_page_translations.page_id
        SET webmasters_cms_page_translation_versions.page_translation_id = webmasters_cms_page_translations.id"
    end
  end
end