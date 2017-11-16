class AddColumnIsMetaToWebmastersCmsPages < ActiveRecord::Migration[4.2]
  def change
    change_table :webmasters_cms_pages do |t|
      t.boolean :is_meta, :null => false, :default => false
      t.index :is_meta,
        :name => 'index_webmasters_cms_pages_on_is_meta'
    end
  end
end
