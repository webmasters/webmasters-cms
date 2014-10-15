class AddColumnIsMetaToWebmastersCmsPages < ActiveRecord::Migration
  def change
    change_table :webmasters_cms_pages do |t|
      t.boolean :is_meta, :null => false, :default => false
      t.index :is_meta
    end
  end
end
