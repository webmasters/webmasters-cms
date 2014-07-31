class MovePagesColumnDataToPageTranslations < ActiveRecord::Migration
  class WebmastersCms::PageTranslation < ActiveRecord::Base
    self.record_timestamps = false
  end

  class WebmastersCms::Page < ActiveRecord::Base
    has_many :translations, class_name: WebmastersCms::PageTranslation.to_s
  end
  
  def up
    transaction do
      WebmastersCms::Page.all.each do |page|
        page.translations.create!(
          name: page.name,
          local_path: page.local_path,
          title: page.title,
          meta_description: page.meta_description,
          body: page.body,
          created_at: page.created_at,
          updated_at: page.updated_at,
          version: page.version,
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
