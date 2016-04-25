class AddColumnMenuIconCssClassToWebmastersCmsPageTranslations < ActiveRecord::Migration
  def change
    add_column :webmasters_cms_page_translations, :menu_icon_css_class, :string, :limit => 30
  end
end
