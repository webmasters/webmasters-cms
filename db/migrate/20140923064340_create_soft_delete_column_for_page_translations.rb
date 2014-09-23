class CreateSoftDeleteColumnForPageTranslations < ActiveRecord::Migration
  def up
    add_column :webmasters_cms_page_translations, :soft_deleted, :boolean, default: false
  end

  def down
    delete_column :webmasters_cms_page_translations, :delete
  end
end
