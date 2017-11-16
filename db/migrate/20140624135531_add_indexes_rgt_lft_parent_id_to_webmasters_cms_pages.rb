class AddIndexesRgtLftParentIdToWebmastersCmsPages < ActiveRecord::Migration[4.2]
  def change
    add_index :webmasters_cms_pages, :rgt,
      :name => 'index_webmasters_cms_pages_on_rgt'
    add_index :webmasters_cms_pages, :lft,
      :name => 'index_webmasters_cms_pages_on_lft'
    add_index :webmasters_cms_pages, :parent_id,
      :name => 'index_webmasters_cms_pages_on_parent_id'
  end
end
