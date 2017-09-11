class AddColumnMenuIconCssClassToWebmastersCmsPageTranslations < ActiveRecord::Migration[4.2]
  def change
    add_column :webmasters_cms_page_translations, :menu_icon_css_class, :string, :limit => 30
  end
end
