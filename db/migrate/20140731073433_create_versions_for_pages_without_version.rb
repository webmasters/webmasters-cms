class CreateVersionsForPagesWithoutVersion < ActiveRecord::Migration
  class WebmastersCmsPageTranslation < ActiveRecord::Base
    self.record_timestamps = false
  end

  class WebmastersCmsPageTranslation::Version < ActiveRecord::Base
    self.record_timestamps = false
  end

  def up
    transaction do
      WebmastersCmsPageTranslation.reset_column_information
      WebmastersCmsPageTranslationVersion.reset_column_information

      WebmastersCmsPageTranslation.where(version: 0).each do |page_translation|
        page_translation.update_attributes! version: 1

        WebmastersCms::PageTranslation::Version.create! page_translation_id: page_translation.id,
          name: page_translation.name,
          local_path: page_translation.local_path,
          title: page_translation.title,
          meta_description: page_translation.meta_description,
          body: page_translation.body,
          created_at: page_translation.created_at,
          updated_at: page_translation.updated_at,
          version: page_translation.version
      end
    end
  end
end
