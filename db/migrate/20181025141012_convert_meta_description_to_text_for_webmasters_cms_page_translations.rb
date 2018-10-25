class ConvertMetaDescriptionToTextForWebmastersCmsPageTranslations < ActiveRecord::Migration[5.1]
  def up
    change_table do |t|
      t.change :meta_description, :text
    end
  end

  def down
    change_table do |t|
      t.change :meta_description, :string
    end
  end

  private
  def change_table(&block)
    super :webmasters_cms_page_translations, &block
  end
end
