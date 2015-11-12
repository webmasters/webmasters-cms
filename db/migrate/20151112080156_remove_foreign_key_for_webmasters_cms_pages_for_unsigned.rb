class RemoveForeignKeyForWebmastersCmsPagesForUnsigned < ActiveRecord::Migration
  
  def up
    change_table :webmasters_cms_pages do |t|
      t.remove_foreign_key :name => 'webmasters_cms_pages_parent_id_fk'
    end
  end
  
  def down
    change_table :webmasters_cms_pages do |t|
      t.foreign_key :webmasters_cms_pages,
        :column => 'parent_id',
        :name => 'webmasters_cms_pages_parent_id_fk'
    end
  end
end
