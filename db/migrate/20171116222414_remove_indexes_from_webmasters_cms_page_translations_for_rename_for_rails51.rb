class RemoveIndexesFromWebmastersCmsPageTranslationsForRenameForRails51 < ActiveRecord::Migration[5.1]
  def up
    change_table do |t|
      t.remove_index :name => "wcms_pt_lang_name_index"
      t.remove_index :name => "wcms_pt_lang_loc_path_index"
      t.remove_index :name => "wcms_pt_page_id_index"
      t.remove_index :name => "wcms_pt_lang_index"
      t.remove_index :name => "wcms_pt_soft_del_index"
      t.remove_index :name => "index_webmasters_cms_page_translations_on_local_path"
    end
  end

  def down
    change_table do |t|
      t.index [:language, :name],
        :unique => true,
        :name => "wcms_pt_lang_name_index"
      t.index [:language, :local_path],
        :unique => true,
        :name => "wcms_pt_lang_loc_path_index"
      t.index [:page_id],
        :unique => false,
        :name => "wcms_pt_page_id_index"
      t.index [:language],
        :unique => false,
        :name => "wcms_pt_lang_index"
      t.index [:soft_deleted],
        :unique => false,
        :name => "wcms_pt_soft_del_index"
      t.index [:local_path],
        :unique => false,
        :name => "index_webmasters_cms_page_translations_on_local_path"
    end
  end

  private
  def change_table(&block)
    super :webmasters_cms_page_translations, &block
  end
end
