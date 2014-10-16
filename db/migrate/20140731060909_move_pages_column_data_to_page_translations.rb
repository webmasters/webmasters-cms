class MovePagesColumnDataToPageTranslations < ActiveRecord::Migration
  class WebmastersCmsPageTranslation < ActiveRecord::Base
    self.record_timestamps = false
  end

  class WebmastersCmsPage < ActiveRecord::Base
    has_many :translations, class_name: WebmastersCmsPageTranslation.to_s
  end
  
  def up
    transaction do
      WebmastersCmsPage.reset_column_information
      WebmastersCmsPageTranslation.reset_column_information

      WebmastersCmsPage.all.each do |page|
        page.translations.create!(
          name: page.name,
          local_path: page.local_path,
          title: page.title,
          meta_description: page.meta_description,
          body: page.body,
          created_at: page.created_at,
          updated_at: page.updated_at,
          version: page.version || 0,
          language: "en",
          page_id: page.id
        )
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
