class RemoveIndexesFromWebmastersCmsActiveLanguagesForRenameForRails51 < ActiveRecord::Migration[5.1]
  def up
    change_table do |t|
      t.remove_index :name => "index_webmasters_cms_active_languages_on_code"
    end
  end

  def down
    change_table do |t|
      t.index [:code],
        :unique => true,
        :name => "index_webmasters_cms_active_languages_on_code"
    end
  end

  private
  def change_table(&block)
    super :webmasters_cms_active_languages, &block
  end
end
