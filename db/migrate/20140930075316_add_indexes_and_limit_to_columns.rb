class AddIndexesAndLimitToColumns < ActiveRecord::Migration[4.2]
  def change
    transaction do
      change_column :webmasters_cms_page_translations, :language, :string, limit: 2
      change_column_null :webmasters_cms_page_translations, :soft_deleted, false
      change_column_null :webmasters_cms_page_translations, :redirect_to_child, false
      change_column_null :webmasters_cms_page_translations, :show_in_navigation, false
      add_index :webmasters_cms_page_translations, :page_id, name: 'wcms_pt_page_id_index'
      add_index :webmasters_cms_page_translations, :language, name: 'wcms_pt_lang_index'
      add_index :webmasters_cms_page_translations, :soft_deleted, name: 'wcms_pt_soft_del_index'
    end
  end
end
