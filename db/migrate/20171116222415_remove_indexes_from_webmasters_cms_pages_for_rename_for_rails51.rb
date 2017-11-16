class RemoveIndexesFromWebmastersCmsPagesForRenameForRails51 < ActiveRecord::Migration[5.1]
  def up
    change_table do |t|
      t.remove_index :name => "index_webmasters_cms_pages_on_rgt"
      t.remove_index :name => "index_webmasters_cms_pages_on_lft"
      t.remove_index :name => "index_webmasters_cms_pages_on_parent_id"
      t.remove_index :name => "index_webmasters_cms_pages_on_is_meta"
    end
  end

  def down
    change_table do |t|
      t.index [:rgt],
        :unique => false,
        :name => "index_webmasters_cms_pages_on_rgt"
      t.index [:lft],
        :unique => false,
        :name => "index_webmasters_cms_pages_on_lft"
      t.index [:parent_id],
        :unique => false,
        :name => "index_webmasters_cms_pages_on_parent_id"
      t.index [:is_meta],
        :unique => false,
        :name => "index_webmasters_cms_pages_on_is_meta"
    end
  end

  private
  def change_table(&block)
    super :webmasters_cms_pages, &block
  end
end
